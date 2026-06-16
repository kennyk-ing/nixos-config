{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system/core.nix
    ../../modules/system/security.nix
    ../../modules/system/maintenance.nix

    ../../modules/hardware/firmware.nix
    ../../modules/hardware/laptop.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/system/audio.nix

    ../../modules/desktop/plasma.nix
    ../../modules/apps/firefox.nix

    ../../users/kenny
    ../../users/kenny/workstation.nix
  ];

  networking.hostName = "kirby";

  system.stateVersion = "26.05";
}
