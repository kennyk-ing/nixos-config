{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./wireguard.nix
  ];

  networking.hostName = "earl";
  # The workstation profile enables NetworkManager; its automatic wired
  # connection uses DHCP on the switch's untagged VLAN 10.
  # Temporary LAN administration during installation and migration.
  networking.firewall.allowedTCPPorts = [ 22 ];
  time.timeZone = "America/Los_Angeles";

  boot.initrd.systemd.enable = true;

  mySystem = {
    apps = {
      browsers.enable = true;
      office.enable = true;
    };

    desktop = {
      sddm.enable = true;
      plasma.enable = true;
      niri.enable = true;
    };

    users.kenny = {
      enable = true;
      workstation.enable = true;
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

      secure-boot = {
        enable = true;
        measured-boot.enable = true;
      };

      zram = {
        enable = true;
        memoryPercent = 50;
      };
    };

    services = {
      openssh.enable = true;
      smartd.enable = true;
      syncthing.enable = false;
    };
  };

  # Firmware measurement specific to Earl's physical Dell chassis.
  boot.lanzaboote.measuredBoot.staticMeasurements."610-earl-firmware-efi".json = {
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
