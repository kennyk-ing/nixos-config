{ lib, config, ... }:
let
  cfg = config.mySystem.system.systemd-boot;
in
{
  options.mySystem.system.systemd-boot = {
    enable = lib.mkEnableOption "systemd-boot";
  };

  config = lib.mkIf cfg.enable {
    boot.loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 10;
      };

      efi.canTouchEfiVariables = true;
    };
  };
}
