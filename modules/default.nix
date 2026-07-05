{ ... }:

{
  imports = [
    ./apps/emacs.nix
    ./apps/browsers.nix
    ./apps/gaming.nix
    ./apps/wezterm.nix
    ./desktop/gdm.nix
    ./desktop/niri
    ./desktop/plasma.nix
    ./hardware/intel-graphics.nix
    ./hardware/laptop.nix
    ./hardware/wifi.nix
    ./services/syncthing.nix
    ./system/core.nix
    ./system/workstation.nix
    ./system/graphics.nix
    ./system/zram.nix
    ../users/kenny
    ../users/kenny/workstation.nix
    ../users/karen
  ];
}
