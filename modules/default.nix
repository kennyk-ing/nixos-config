{ ... }:

{
  imports = [
    ./apps/browsers.nix
    ./apps/emacs.nix
    ./apps/gaming.nix
    ./apps/nixvim
    ./apps/office.nix

    ./desktop/gdm.nix
    ./desktop/sddm.nix
    ./desktop/niri
    ./desktop/plasma.nix

    ./hardware/graphics.nix
    ./hardware/intel-graphics.nix
    ./hardware/laptop.nix
    ./hardware/tplink-ethernet2usb.nix

    ./networking/trusted-lan.nix
    ./networking/wifi.nix

    ./profiles/development.nix
    ./profiles/server.nix
    ./profiles/workstation.nix

    ./services/libvirt.nix
    ./services/openssh.nix
    ./services/plex.nix
    ./services/podman.nix
    ./services/syncthing.nix
    ./services/tailscale.nix

    ./system/core.nix
    ./system/mobile.nix
    ./system/systemd-boot.nix
    ./system/zram.nix
  ];
}
