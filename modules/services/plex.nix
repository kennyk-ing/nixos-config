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

    users.groups.media.gid = lib.mkDefault 2000;

    systemd.services.plex.serviceConfig.SupplementaryGroups = [
      "media"
    ];
  };
}
