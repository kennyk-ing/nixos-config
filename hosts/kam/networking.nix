{ lib, ... }:
let
  # Confirm the target adapter; Kirby's MAC belongs to the other chassis/adapter.
  parentMAC = null;
in

{
  networking.firewall.interfaces = {
    vlan100.allowedTCPPorts = [
      22 # SSH
      22000 # Syncthing
    ];
  };

  # No active VLAN attachment until the physical adapter is known.
  systemd.network = lib.mkIf (parentMAC != null) {
    netdevs = {
      "20-vlan100" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan100";
        };
        vlanConfig.Id = 100;
      };
    };

    networks = {
      "10-parent" = {
        matchConfig.PermanentMACAddress = parentMAC;

        vlan = [ "vlan100" ];

        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };

      # Kam's eventual management/server network.
      "30-vlan100" = {
        matchConfig.Name = "vlan100";

        networkConfig.DHCP = "ipv4";
        linkConfig = {
          RequiredForOnline = "routable";
          RequiredFamilyForOnline = "ipv4";
        };
      };
    };
  };
}
