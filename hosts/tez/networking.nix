{ ... }:

{
  networking = {
    firewall.interfaces = {
      enp14s0.allowedTCPPorts = [
        22 # SSH
        32400 # Plex
        8989 # Sonarr
        7878 # Radarr
        9696 # Prowlarr
        6767 # Bazarr
        5055 # Seerr
      ];

      tailscale0.allowedTCPPorts = [
        22 # SSH
      ];
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
