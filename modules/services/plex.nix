{ lib, config, ... }:

let
  cfg = config.mySystem.services.plex;
in
{
  options.mySystem.services.plex = {
    enable = lib.mkEnableOption "Plex Media Server";
  };

  config = lib.mkIf cfg.enable {
    services.plex = {
      enable = true;
    };
  };
}
