{ lib, config, ... }:
let
  cfg = config.mySystem.services.syncthing;
in
{
  options.mySystem.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.mySystem.services.tailscale.enable;
        message = "Syncthing requires Tailscale to be enabled.";
      }
    ];

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22000 ];
  };
}
