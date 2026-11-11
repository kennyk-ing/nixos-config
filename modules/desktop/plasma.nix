{ lib, config, ... }:
let
  cfg = config.mySystem.desktop.plasma;
in
{
  options.mySystem.desktop.plasma = {
    enable = lib.mkEnableOption "Plasma 6 Desktop Environment";
  };

  config = lib.mkIf cfg.enable {
    services.desktopManager.plasma6.enable = true;

    # Workaround for DrKonqi's recursive coredump crash loop
    # in Plasma 6.6.x. Remove after upgrading to a fixed release.
    systemd.user.units."drkonqi-coredump-launcher.socket".enable = false;
  };
}
