{ ... }:

{
  imports = [
    ./apps/browsers.nix
    ./apps/emacs.nix
    ./apps/gaming.nix
    ./apps/nixvim
    ./apps/office.nix
    ./apps/wezterm.nix

    ./desktop/gdm.nix
    ./desktop/sddm.nix
    ./desktop/niri
    ./desktop/plasma.nix

    ./hardware/intel-graphics.nix
    ./hardware/laptop.nix
    ./hardware/tplink-ethernet2usb.nix
    ./hardware/wifi.nix

    ./profiles/development.nix

    ./services/openssh.nix
    ./services/plex.nix
    ./services/podman.nix
    ./services/syncthing.nix
    ./services/tailscale.nix

    ./system/core.nix
    ./system/graphics.nix
    ./system/workstation.nix
    ./system/zram.nix
  ];
}
