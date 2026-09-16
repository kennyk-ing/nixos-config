{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.services.smartd;
in
{
  options.mySystem.services.smartd = {
    enable = lib.mkEnableOption "SMART disk monitoring";
  };

  config = lib.mkIf cfg.enable {
    services.smartd.enable = true;

    environment.systemPackages = [
      pkgs.smartmontools
    ];
  };
}
