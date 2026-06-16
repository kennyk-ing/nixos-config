{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "kirby";

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  age.secrets.wifi.file = ../../secrets/wifi.age;

  mySystem.apps.firefox.enable = true;
  mySystem.apps.gaming.enable = true;
  mySystem.desktop.displayManager.enable = true;
  mySystem.desktop.plasma.enable = true;
  mySystem.desktop.printing.enable = true;
  mySystem.users.kenny.enable = true;
  mySystem.users.kenny.workstation.enable = true;
  mySystem.hardware.audio.enable = true;
  mySystem.hardware.bluetooth.enable = true;
  mySystem.hardware.firmware.enable = true;
  mySystem.hardware.intel-graphics.enable = true;
  mySystem.hardware.laptop.enable = true;
  mySystem.hardware.ssd.enable = true;
  mySystem.hardware.wifi.enable = true;
  mySystem.system.core.enable = true;

  system.stateVersion = "26.05";
}
