{ config, lib, ... }:

let
  cfg = config.mySystem.system.zram;
in
{
  options.mySystem.system.zram = {
    enable = lib.mkEnableOption "Enable ZRAM swap";
    memoryPercent = lib.mkOption {
      type = lib.types.int;
      default = 50;
      description = "Percentage of system memory to use for ZRAM.";
    };
  };

  config = lib.mkIf cfg.enable {
    zramSwap = {
      enable = true;
      memoryPercent = cfg.memoryPercent;
      algorithm = "zstd";
    };
  };
}
