{ lib, config, ... }:
let
  cfg = config.mySystem.desktop.printing;
in
{
  options.mySystem.desktop.printing = {
    enable = lib.mkEnableOption "CUPS Printing Service";
  };

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
  };
}
