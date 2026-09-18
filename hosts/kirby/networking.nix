{ ... }:

{
  networking.firewall.interfaces = {
    vlan100.allowedTCPPorts = [ 22 ];
    tailscale0.allowedTCPPorts = [ 22 ];
  };

  systemd.network = {
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
        matchConfig.PermanentMACAddress = "9c:69:d3:81:48:ea";

        vlan = [ "vlan100" ];

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
    };
  };
}
