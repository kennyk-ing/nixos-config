{
  networking.firewall = {
    interfaces = {
      vlan100.allowedTCPPorts = [
        22 # SSH
      ];
    };

    # Application backends are accessed through Caddy on kingdome.
    #
    # Restrict direct connections to kingdome (10.0.10.2).
    # Users access these services through their HTTPS URLs.
    #
    # TCP 8888: SearXNG
    # TCP 9000: Mealie
    # TCP 8000: Audiobookshelf
    # TCP 5000: Kavita
    #
    # NixOS owns the nixos-fw chain and recreates it on reload.
    extraCommands = ''
      iptables -A nixos-fw -i vlan100 -s 10.0.10.2/32 -p tcp \
        -m multiport --dports 8888,9000,8000,5000 -j nixos-fw-accept
    '';
  };

  systemd.network = {
    netdevs."20-vlan100" = {
      netdevConfig = {
        Kind = "vlan";
        Name = "vlan100";
      };
      vlanConfig.Id = 100;
    };

    networks = {
      "10-parent" = {
        matchConfig.PermanentMACAddress = "9c:69:d3:81:48:ea";

        vlan = [ "vlan100" ];

        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "no";
      };

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
