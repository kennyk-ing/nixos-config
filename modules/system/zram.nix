{ config, lib, ... }:

let
  cfg = config.mySystem.system.zram;
in
{
  options.mySystem.system.zram = {
    enable = lib.mkEnableOption "Enable ZRAM swap";
    memoryPercent = lib.mkOption {
      type = lib.types.ints.between 1 100;
      default = 50;
      description = "Percentage of system memory to use for ZRAM.";
    };
  };

  config = lib.mkIf cfg.enable {
    zramSwap = {
      inherit (cfg) memoryPercent;
      enable = true;
      algorithm = "zstd";
    };
  };
}
