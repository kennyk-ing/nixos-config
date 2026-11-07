{ config, lib, ... }:

let
  cfg = config.mySystem.networking.home-vpn;
in
{
  options.mySystem.networking.home-vpn = {
    enable = lib.mkEnableOption "Earl's road-warrior WireGuard profile";
    address = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.strMatching "10\\.253\\.0\\.([3-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])/32"
      );
      default = null;
      description = "Earl's unique VPN address, reserved on OPNsense before enabling.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.address != null && cfg.address != "10.253.0.2/32";
        message = "Reserve a unique home-vpn.address for Earl; 10.253.0.2/32 belongs to Woo.";
      }
      {
        assertion = config.networking.networkmanager.enable;
        message = "Earl's home-vpn requires NetworkManager.";
      }
    ];

    age.secrets.wireguard-earl = {
      file = ../../secrets/wireguard-earl.age;
      mode = "0400";
    };

    networking = {
      firewall.interfaces."wg-home".allowedTCPPorts = [ 22 ];

      networkmanager.ensureProfiles = {
        # Substitute at runtime; never read decrypted key material during evaluation.
        environmentFiles = [ config.age.secrets.wireguard-earl.path ];

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
            address1 = if cfg.address == null then "" else cfg.address;
            never-default = true;
            dns = "10.253.0.1;";
            dns-search = "home.kinghq.net;";
            dns-priority = 50;
          };

          ipv6.method = "disabled";
        };
      };
    };
  };

}
