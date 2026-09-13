{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./storage.nix
  ];

  networking.hostName = "tez";
  time.timeZone = "America/Los_Angeles";

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

    hardware.graphics.enable = true;

    networking.trusted-lan.enable = true;

    profiles = {
      development.enable = true;
      workstation.enable = true;
    };

    system = {
      core.enable = true;
      systemd-boot.enable = true;
      zram.enable = true;
    };

    services = {
      openssh.enable = true;
      syncthing.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
