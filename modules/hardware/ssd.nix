{ lib, config, ... }:

let
  cfg = config.mySystem.hardware.ssd;
in {
  options.mySystem.hardware.ssd = {
    enable = lib.mkEnableOption "SSD optimizations like fstrim";
  };

  config = lib.mkIf cfg.enable {
    # Run weekly fstrim to maintain SSD performance
    services.fstrim.enable = true;
  };
}
