{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "kirby";
  time.timeZone = "America/Los_Angeles";

  users.users.kenny.linger = true;

  mySystem = {
    apps = {
      emacs.enable = true;
      browsers.enable = true;
      gaming.enable = true;
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
    };

    hardware = {
      intel-graphics.enable = true;
      laptop.enable = true;
    };

    networking = {
      trusted-lan.enable = true;
      wifi.enable = true;
    };

    profiles = {
      development.enable = true;
      workstation.enable = true;
    };

    services = {
      openssh.enable = true;
      smartd.enable = true;
      syncthing.enable = true;
      tailscale.enable = true;
    };

    system = {
      core.enable = true;
      secure-boot = {
        enable = true;
      };

      zram = {
        enable = true;
        memoryPercent = 10;
      };
    };
  };

  system.stateVersion = "26.05";
}
