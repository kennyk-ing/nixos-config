{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "woo";
  time.timeZone = "America/Los_Angeles";

  age.secrets.wireguard-woo = {
    file = ../../secrets/wireguard-woo.age;
    mode = "0400";
  };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.age.secrets.wireguard-woo.path ];

    profiles.home-vpn = {
      connection = {
        id = "Home VPN";
        type = "wireguard";
        interface-name = "wg-home";
        autoconnect = false;
        permissions = "user:kenny:;";
      };

      wireguard = {
        private-key = "$WG_HOME_PRIVATE_KEY";
        private-key-flags = 0;
        peer-routes = true;
      };

      "wireguard-peer.wSJ+pp7eHP74vH+0Ab6DrZK47V05+zyU+UAmtGj4rEU=" = {
        endpoint = "vpn.kinghq.net:51820";
        allowed-ips = "10.253.0.0/24;10.0.10.2/32;";
        persistent-keepalive = 25;
      };

      ipv4 = {
        method = "manual";
        address1 = "10.253.0.2/32";
        never-default = true;
        dns = "10.253.0.1;";
        dns-search = "~home.kinghq.net;";
        dns-priority = 50;
      };

      ipv6.method = "disabled";
    };
  };

  mySystem = {
    apps = {
      emacs.enable = true;
      browsers.enable = true;
      office.enable = true;
    };

    desktop = {
      sddm.enable = true;
      plasma.enable = true;
    };

    users = {
      kenny = {
        enable = true;
        workstation.enable = true;
      };
      karen.enable = true;
      keegan.enable = true;
    };

    hardware = {
      intel-graphics.enable = true;
      laptop.enable = true;
    };

    networking.wifi.enable = true;

    profiles = {
      development.enable = true;
      workstation.enable = true;
    };

    system = {
      core.enable = true;
      mobile.enable = true;
      systemd-boot.enable = true;

      zram = {
        enable = true;
        memoryPercent = 50;
      };
    };

    services = {
      openssh.enable = true;
      smartd.enable = true;
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
