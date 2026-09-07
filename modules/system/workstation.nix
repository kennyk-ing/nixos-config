{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.system.workstation;
in
{
  options.mySystem.system.workstation = {
    enable = lib.mkEnableOption "Core workstation profile";
  };

  config = lib.mkIf cfg.enable {
    # Required for PipeWire to get realtime scheduling
    security.rtkit.enable = true;

    services = {
      # --- Audio ---
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # --- Power Management ---
      upower.enable = true;
      power-profiles-daemon.enable = true;

      # --- Hardware Maintenance ---
      fwupd.enable = true;

      # --- Network Discovery ---
      avahi = {
        enable = true;
        nssmdns4 = true;
      };

      # --- Printing (CUPS) ---
      printing.enable = true;
    };

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

    # --- Basic System Fonts ---
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };
}
