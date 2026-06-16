{ lib, config, ... }:
let
  cfg = config.mySystem.apps.firefox;
in
{
  options.mySystem.apps.firefox = {
    enable = lib.mkEnableOption "Firefox Web Browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
  };
}

