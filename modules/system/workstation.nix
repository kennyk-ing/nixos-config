{ config, lib, pkgs, ... }:

let
  cfg = config.mySystem.system.workstation;
in
{
  options.mySystem.system.workstation = {
    enable = lib.mkEnableOption "Core workstation profile";
  };

  config = lib.mkIf cfg.enable {
    # --- Audio (PipeWire) ---
    security.rtkit.enable = true; # Required for PipeWire to get realtime scheduling
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # --- Power Management ---
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;

    # --- Bluetooth ---
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # Needed for modern headphones/battery reporting
        };
      };
    };

    # --- Core GUI Support ---
    security.polkit.enable = true;
    programs.dconf.enable = true;

    # --- Printing (CUPS) ---
    services.printing.enable = true;

    # --- Basic System Fonts ---
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
