{ config, lib, ... }:
let
  cfg = config.mySystem.system.mobile;
in
{
  options.mySystem.system.mobile = {
    enable = lib.mkEnableOption "mobile system security policy";
  };

  config = lib.mkIf cfg.enable {
    # If openssh and tailscale are both enabled:
    # open port 22 on the tailscale interface only
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = lib.optionals (
      config.mySystem.services.openssh.enable && config.mySystem.services.tailscale.enable
    ) [ 22 ];
  };
}
