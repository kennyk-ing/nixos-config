{ lib, config, ... }:

let
  cfg = config.mySystem.hardware.graphics;
in
{
  options.mySystem.hardware.graphics = {
    enable = lib.mkEnableOption "Base Graphics and 32-bit Support";
  };

  config = lib.mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
