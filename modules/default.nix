{ ... }:

{
  imports = [
    ./apps/firefox.nix
    ./apps/gaming.nix
    ./desktop/display-manager.nix
    ./desktop/plasma.nix
    ./desktop/printing.nix
    ./hardware/audio.nix
    ./hardware/bluetooth.nix
    ./hardware/firmware.nix
    ./hardware/graphics.nix
    ./hardware/intel-graphics.nix
    ./hardware/laptop.nix
    ./hardware/ssd.nix
    ./hardware/wifi.nix
    ./services/syncthing.nix
    ./system/core.nix
    ../users/kenny
    ../users/kenny/workstation.nix
  ];
}
