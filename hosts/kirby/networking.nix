{ ... }:

{
  systemd.network = {
    netdevs = {
      "20-vlan100" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan100";
        };
        vlanConfig.Id = 100;
      };

      "20-vlan110" = {
        netdevConfig = {
          Kind = "vlan";
          Name = "vlan110";
        };
        vlanConfig.Id = 110;
      };
    };

    networks = {
      "10-parent" = {
        matchConfig.PermanentMACAddress = "9c:69:d3:81:48:ea";

        vlan = [
          "vlan100"
          "vlan110"
        ];

        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };

      # Kirby's eventual management/server network.
      "30-vlan100" = {
        matchConfig.Name = "vlan100";

        networkConfig.DHCP = "ipv4";
        linkConfig = {
          RequiredForOnline = "routable";
          RequiredFamilyForOnline = "ipv4";
        };
      };

      # Carried to Kirby for isolated workloads. The Kirby host itself
      # must not acquire an address or route on VLAN 110.
      "30-vlan110" = {
        matchConfig.Name = "vlan110";

        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };
    };
  };
}
