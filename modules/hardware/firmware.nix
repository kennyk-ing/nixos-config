{ lib, config, ... }:

let
  cfg = config.mySystem.hardware.firmware;
in {
  options.mySystem.hardware.firmware = {
    enable = lib.mkEnableOption "Essential hardware firmware and fwupd";
  };

  config = lib.mkIf cfg.enable {
    hardware.enableRedistributableFirmware = true;
    services.fwupd.enable = true;
  };
}
