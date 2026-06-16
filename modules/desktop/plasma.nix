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
  };
}
