{ lib, config, ... }:
let
  cfg = config.mySystem.hardware.bluetooth;
in
{
  options.mySystem.hardware.bluetooth = {
    enable = lib.mkEnableOption "Bluetooth w/ blueman applet";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true; # Often needed for modern headsets
        };
      };
    };

    services.blueman.enable = true; 
  };
}

