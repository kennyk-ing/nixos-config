{ lib, ... }:

{
  # Staged VPN profile: enable only after allocating an Earl peer/address and
  # declaring a new agenix secret supplying WG_HOME_PRIVATE_KEY at this path.
  networking = lib.mkIf false {
    firewall.interfaces."wg-home".allowedTCPPorts = [ 22 ];

    networkmanager.ensureProfiles = {
      environmentFiles = [ "/run/agenix/wireguard-earl" ];

      profiles.home-vpn = {
        connection = {
          id = "Home VPN";
          type = "wireguard";
          interface-name = "wg-home";
          autoconnect = true;
        };

        wireguard = {
          private-key = "$WG_HOME_PRIVATE_KEY";
          private-key-flags = 0;
          peer-routes = true;
        };

        "wireguard-peer.wSJ+pp7eHP74vH+0Ab6DrZK47V05+zyU+UAmtGj4rEU=" = {
          endpoint = "vpn.kinghq.net:51820";
          # WireGuard tunnel plus explicitly permitted remote hosts.
          allowed-ips = "10.253.0.0/24;10.0.10.2/32;10.0.10.20/32;10.0.100.10/32;";
          persistent-keepalive = 25;
        };

        ipv4 = {
          method = "manual";
          # Add a newly allocated address1; 10.253.0.2 remains Woo's address.
          dns = "10.253.0.1;";
          dns-search = "home.kinghq.net;";
          dns-priority = 50;
        };

        ipv6.method = "disabled";
      };
    };
  };

}
