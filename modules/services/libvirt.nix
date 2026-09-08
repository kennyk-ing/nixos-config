{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.services.libvirt;
in
{
  options.mySystem.services.libvirt = {
    enable = lib.mkEnableOption "libvirt virtualization";
  };

  config = lib.mkIf cfg.enable {
    # Required by the NixOS libvirt module.
    security.polkit.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
    };
  };
}
