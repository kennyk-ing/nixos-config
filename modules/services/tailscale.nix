{ lib, config, ... }:
let
  cfg = config.mySystem.services.tailscale;
in {
  options.mySystem.services.tailscale = {
    enable = lib.mkEnableOption "Tailscale";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
  };
}
