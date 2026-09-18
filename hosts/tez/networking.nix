{ ... }:

{
  networking = {
    firewall.interfaces = {
      enp14s0.allowedTCPPorts = [
        22 # SSH
        32400 # Plex
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
