{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  networking.hostName = "woo";
  time.timeZone = "America/Los_Angeles";

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
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
