{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
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
      wifi.enable = true;
    };
    profiles = {
      development.enable = true;
    };
    system = {
      core.enable = true;
      workstation.enable = true;
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
