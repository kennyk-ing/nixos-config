{ lib, config, pkgs, ... }:

let
  cfg = config.mySystem.hardware.intel-graphics;
in {
  options.mySystem.hardware.intel-graphics = {
    enable = lib.mkEnableOption "Intel Integrated Graphics (i915 and Media Drivers)";
  };

  config = lib.mkIf cfg.enable {
    mySystem.system.graphics.enable = true;

    hardware.graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        intel-compute-runtime
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        intel-vaapi-driver
      ];
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "iHD"; 
    };
  };
}
