{ config, lib, ... }:

let
  cfg = config.mySystem.networking.trusted-lan;
in
{
  options.mySystem.networking.trusted-lan = {
    enable = lib.mkEnableOption "trusted-lan system network policy";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.optionals config.mySystem.services.openssh.enable [ 22 ];
  };
}
