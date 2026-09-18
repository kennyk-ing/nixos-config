{ pkgs, ... }:

{
  users.groups.media.gid = 2000;

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

        firewall.allowedTCPPorts = [ 8080 ];

        interfaces.mv-vlan110.ipv4.addresses = [
          {
            address = "10.0.110.10";
            prefixLength = 24;
          }
        ];

        defaultGateway = {
          address = "10.0.110.1";
          interface = "mv-vlan110";
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
        webuiPort = 8080;
        openFirewall = false;

        extraArgs = [ "--confirm-legal-notice" ];
      };

      systemd.services.qbittorrent.serviceConfig.UMask = "0002";

      # Do not change after initial deployment.
      system.stateVersion = "26.05";
    };
  };
}
