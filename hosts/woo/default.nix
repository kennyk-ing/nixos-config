{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = true;
  };

  networking.hostName = "woo";
  time.timeZone = "America/Los_Angeles";

  age = {
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      wifi.file = ../../secrets/wifi.age;
      email_personal = {
        file = ../../secrets/email_personal.age;
        owner = "kenny";
      };
    };
  };

  mySystem = {
    apps = {
      emacs.enable = true;
      firefox.enable = true;
      wezterm.enable = true;
    };
    desktop = {
      gdm.enable = true;
      niri.enable = true;
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
      wifi.enable = true;
    };
    system = {
      core.enable = true;
      workstation.enable = true;
      zram = {
        enable = true;
        memoryPercent = 50;
      };
    };
    services.syncthing.enable = true;
  };


  environment.sessionVariables = {
    LIBVA_MESSAGING_LEVEL = "1";
  };

  system.stateVersion = "26.05";
}
