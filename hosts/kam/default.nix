{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix
  ];

  networking.hostName = "kam";
  time.timeZone = "America/Los_Angeles";

  users.users.kenny.linger = true;

  age.secrets."gotify-token".file = ../../secrets/gotify-token.age;

  mySystem = {
    desktop = {
      sddm.enable = true;
      plasma.enable = true;
    };

    users.kenny.enable = true;

    hardware = {
      intel-graphics.enable = true;
      laptop.enable = true;
    };

    profiles.server.enable = true;

    services = {
      openssh.enable = true;
      # Fresh identity and peer/folder review are deferred.
      syncthing.enable = false;

      smartd = {
        enable = true;
        gotify = {
          enable = true;
          tokenFile = config.age.secrets."gotify-token".path;
          url = "https://gotify.home.kinghq.net/message";
        };
      };
    };

    system = {
      core.enable = true;
      # Former woo chassis: prepare firmware trust before Lanzaboote.
      systemd-boot.enable = true;

      zram = {
        enable = true;
        # Scales with installed RAM: nominally 6.4 GiB at 64 GiB RAM.
        memoryPercent = 10;
      };
    };
  };

  services = {
    tlp.settings.PLATFORM_PROFILE_ON_AC = "balanced";

    # Behave like a server with the lid closed
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };

  # You are a server! Stay awake!
  systemd.sleep.settings.Sleep = {
    AllowSuspend = false;
    AllowHibernation = false;
    AllowHybridSleep = false;
    AllowSuspendThenHibernate = false;
  };

  system.stateVersion = "26.05";
}
