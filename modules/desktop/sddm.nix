{ lib, config, ... }:
let
  cfg = config.mySystem.desktop.sddm;
in
{
  options.mySystem.desktop.sddm = {
    enable = lib.mkEnableOption "SDDM Display Manager";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.sddm.enable = true;
  };
}
