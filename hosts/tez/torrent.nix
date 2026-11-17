{ pkgs, ... }:
let
  # Fixed network identity for the torrent container.
  #
  # Keep these values in one place because the address and BitTorrent port
  # are referenced by both the container networking configuration and the
  # qBittorrent startup sanity check below.
  torrentInterface = "mv-vlan110";
  torrentAddress = "10.0.110.10";
  torrentGateway = "10.0.110.1";

  # 58008 is also forwarded to this container by Hodor/TorGuard.
  torrentPort = 58008;

  webuiPort = 8080;
in
{
  systemd.services."container@torrent" = {
    bindsTo = [ "srv-data.mount" ];
    after = [ "srv-data.mount" ];
  };

  containers.torrent = {
    autoStart = true;
    macvlans = [ "vlan110" ];

    bindMounts."/data" = {
      hostPath = "/srv/data";
      isReadOnly = false;
    };

    config = {
      users.groups.media.gid = 2000;
      users.users.qbittorrent.uid = 2001;

      networking = {
        enableIPv6 = false;
        useDHCP = false;
        useHostResolvConf = false;

        firewall = {
          allowedTCPPorts = [
            webuiPort
            torrentPort
          ];

          allowedUDPPorts = [
            torrentPort
          ];
        };

        interfaces.${torrentInterface}.ipv4.addresses = [
          {
            address = torrentAddress;
            prefixLength = 24;
          }
        ];

        defaultGateway = {
          address = torrentGateway;
          interface = torrentInterface;
        };

        # Prefer the DNS server from your TorGuard-generated config here.
        # If none was supplied, use a public resolver for the initial test.
        nameservers = [ "1.1.1.1" ];
      };

      environment.systemPackages = with pkgs; [
        curl
        iproute2
      ];

      services.qbittorrent = {
        enable = true;
        group = "media";

        inherit webuiPort;
        torrentingPort = torrentPort;

        openFirewall = false;

        extraArgs = [ "--confirm-legal-notice" ];
      };

      systemd.services.qbittorrent = {
        /*
          qBittorrent/libtorrent can occasionally initialize immediately
          after this container's network becomes "online" without attaching
          its peer sockets to mv-vlan110.

          We observed this directly after a reboot:

            - qBittorrent requested 0.0.0.0:58008.
            - TCP and UDP peer sockets were created only on 127.0.0.1.
            - mv-vlan110 was configured as 10.0.110.10.
            - Restarting only qbittorrent.service immediately caused both
              TCP and UDP sockets to bind correctly to 10.0.110.10.

          This is consistent with the upstream qBittorrent/libtorrent class
          of network-interface rebinding problems:

            https://github.com/qbittorrent/qBittorrent/issues/21288

          network-online.target is already part of the stock NixOS
          qbittorrent.service ordering, so adding another dependency on it
          would not fix the observed race.

          Instead, after qBittorrent starts, verify that both its TCP and UDP
          peer sockets actually exist on the container's static VLAN address.
          Give normal startup up to five seconds to complete.

          If either socket is missing, postStart fails the service. systemd's
          Restart=on-failure then restarts qBittorrent, causing libtorrent to
          re-enumerate the interfaces after networking has settled.

          This intentionally restarts only qBittorrent, not the whole
          container, and avoids relying on an arbitrary fixed boot delay.

          Remove this workaround once an upstream qBittorrent/libtorrent fix
          for reliable interface rebinding is included in our packaged
          version and has been verified here.
        */
        postStart = ''
          for _ in $(${pkgs.coreutils}/bin/seq 1 10); do
            tcp_ready=false
            udp_ready=false

            if ${pkgs.iproute2}/bin/ss -H -ltn4 "sport = :${toString torrentPort}" \
              | ${pkgs.gnugrep}/bin/grep -Fq "${torrentAddress}"; then
              tcp_ready=true
            fi

            if ${pkgs.iproute2}/bin/ss -H -lun4 "sport = :${toString torrentPort}" \
              | ${pkgs.gnugrep}/bin/grep -Fq "${torrentAddress}"; then
              udp_ready=true
            fi

            if "$tcp_ready" && "$udp_ready"; then
              exit 0
            fi

            ${pkgs.coreutils}/bin/sleep 0.5
          done

          echo \
            "qBittorrent failed to bind TCP/UDP ${torrentAddress}:${toString torrentPort}" \
            >&2
          exit 1
        '';

        serviceConfig = {
          UMask = "0002";

          # A failed postStart check means qBittorrent initialized without
          # usable peer sockets. Restart it so libtorrent can bind again once
          # the container network has fully settled.
          Restart = "on-failure";
          RestartSec = "2s";
        };
      };

      # Do not change after initial deployment.
      system.stateVersion = "26.05";
    };
  };
}
