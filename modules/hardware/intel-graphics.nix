{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.hardware.intel-graphics;
in
{
  options.mySystem.hardware.intel-graphics = {
    enable = lib.mkEnableOption "Intel Integrated Graphics (i915 and Media Drivers)";
  };

  config = lib.mkIf cfg.enable {
    mySystem.hardware.graphics.enable = true;

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD";
      LIBVA_MESSAGING_LEVEL = "1";
    };
  };
}
