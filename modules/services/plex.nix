{ lib, config, ... }:

let
  cfg = config.mySystem.services.plex;
in {
  options.mySystem.services.plex = {
    enable = lib.mkEnableOption "Plex Media Server";
  };

  config = lib.mkIf cfg.enable {
    services.plex = {
      enable = true;
      openFirewall = true; # Automatically opens TCP 32400 and required DLNA ports
    };

    users.users.kenny.extraGroups = [ "plex" ];

    # Declaratively create /srv/media and subfolders
    # Type  Path                 Mode  User   Group  Age  Argument
    systemd.tmpfiles.rules = [
      "d    /srv/media           2775  kenny  plex   -    -"
      "d    /srv/media/movies    2775  kenny  plex   -    -"
      "d    /srv/media/tv        2775  kenny  plex   -    -"
    ];
  };
}
