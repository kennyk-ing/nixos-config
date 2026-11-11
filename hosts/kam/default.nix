{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix
    ./backup.nix
    ./searxng.nix
    ./mealie.nix
  ];

  networking.hostName = "kam";
  time.timeZone = "America/Los_Angeles";

  users.users.kenny.linger = true;

  age.secrets."gotify-token".file = ../../secrets/gotify-token.age;

  programs.firefox.enable = true;
  home-manager.users.kenny.home.sessionVariables.BROWSER = "firefox";
  home-manager.users.kenny.xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "application/xhtml+xml" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };
  };

  mySystem = {
    desktop.niri.enable = true;
    desktop.greetd.enable = true;
    profiles.server.enable = true;
    users.kenny.enable = true;
    users.kenny.terminal.enable = true;

    hardware = {
      intel-graphics.enable = true;
      laptop.enable = true;
    };

    services = {
      openssh.enable = true;

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

      secure-boot = {
        enable = true;
        measured-boot.enable = true;
      };

      zram = {
        enable = true;
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
