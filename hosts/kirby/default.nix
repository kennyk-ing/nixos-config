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

  system.stateVersion = "26.05";
}
