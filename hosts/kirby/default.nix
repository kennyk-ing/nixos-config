{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix
  ];

  networking.hostName = "kirby";
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
      syncthing.enable = true;
      tailscale.enable = true;

      smartd = {
        enable = true;
        gotify = {
          enable = true;
          tokenFile = config.age.secrets."gotify-token".path;
          url = "https://kingdome.tail38696f.ts.net/message";
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

  # Kirby's firmware measures an extra EFI application into PCR 4.
  # systemd-pcrlock does not recognize it automatically.
  boot.lanzaboote.measuredBoot.staticMeasurements."610-kirby-firmware-efi".json = {
    records = [
      {
        pcr = 4;
        digests = [
          {
            hashAlg = "sha256";
            digest = "522944324bb55c06f770c2757d962e562d9714d6041b6ba1a93041dd4cf9a8c7";
          }
        ];
      }
    ];
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
