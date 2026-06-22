{ lib, config, ... }:
let
  cfg = config.mySystem.services.syncthing;
in {
  options.mySystem.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8384 22000 ];
    networking.firewall.allowedUDPPorts = [ 22000 21027 ];

    home-manager.users."kenny" = {
      services.syncthing = {
        enable = true;
      };
    };
  };
}
