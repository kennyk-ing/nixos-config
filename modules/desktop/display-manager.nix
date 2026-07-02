{ lib, config, ... }:
let
  cfg = config.mySystem.desktop.displayManager;
in {
  options.mySystem.desktop.displayManager = {
    enable = lib.mkEnableOption "My Current Default Display Manager";
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
