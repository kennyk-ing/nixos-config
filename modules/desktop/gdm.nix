{ lib, config, ... }:
let
  cfg = config.mySystem.desktop.gdm;
in {
  options.mySystem.desktop.gdm = {
    enable = lib.mkEnableOption "GDM Display Manager";
  };

  config = lib.mkIf cfg.enable {
    # Even if you use Wayland, NixOS still requires this base setting turned
    # on for display managers to function correctly
    services.xserver.enable = true;

    services.displayManager.gdm.enable = true;

    # helps GDM remember each users last session type.
    services.accounts-daemon.enable = true;
  };
}
