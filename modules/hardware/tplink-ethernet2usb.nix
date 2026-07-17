{ config, lib, ... }:

let
  cfg = config.mySystem.hardware.tplink-ethernet2usb;
in {
  options.mySystem.hardware.tplink-ethernet2usb = {
    enable = lib.mkEnableOption "tp-link ethernet to USB adapter - ASIX AX88179B USB Ethernet fixes (NO-CARRIER bug)";
  };
  config = lib.mkIf cfg.enable {
    # Stop TLP from forcing the adapter into USB autosuspend, which causes the NO-CARRIER state
    # The hardcoded bit is the USB ID of my actual device
    services.tlp.settings = {
      USB_DENYLIST = "0b95:1790";
    };
  };
}
