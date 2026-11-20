{ ... }:

{
  networking = {
    firewall = {
      interfaces.enp14s0.allowedTCPPorts = [
        22 # SSH
        22000 # Syncthing
        32400 # Plex clients
      ];

      # Restrict application backends to Kingdome's reverse proxy
      # and NFS access to Kam.
      #
      # Kingdome (10.0.10.2):
      # TCP 8989: Sonarr (TV library management).
      # TCP 7878: Radarr (movie library management).
      # TCP 9696: Prowlarr (indexer management).
      # TCP 6767: Bazarr (subtitle management).
      # TCP 5055: Seerr (media requests).
      # TCP 8080: Open WebUI (local AI interface).
      #
      # Kam (10.0.100.10):
      # TCP 2049: NFSv4 (read-only book library).
      #
      # The NixOS firewall owns and recreates nixos-fw on reload.
      extraCommands = ''
        # Application backends: Kingdome only.
        iptables -A nixos-fw -i enp14s0 -s 10.0.10.2/32 -p tcp \
          -m multiport --dports 8989,7878,9696,6767,5055,8080 -j nixos-fw-accept

        # NFSv4: Kam only.
        iptables -A nixos-fw -i enp14s0 -s 10.0.100.10/32 -p tcp \
          --dport 2049 -j nixos-fw-accept
      '';
    };

    networkmanager.ensureProfiles.profiles.vlan110 = {
      connection = {
        id = "vlan110";
        type = "vlan";
        interface-name = "vlan110";
        autoconnect = true;
      };

      vlan = {
        id = 110;
        parent = "enp14s0";
      };

      ipv4.method = "disabled";
      ipv6.method = "disabled";
    };
  };
}
