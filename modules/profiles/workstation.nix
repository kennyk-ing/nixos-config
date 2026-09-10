{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.profiles.workstation;
in
{
  options.mySystem.profiles.workstation = {
    enable = lib.mkEnableOption "Workstation Profile";
  };

  config = lib.mkIf cfg.enable {
    # --- Networking ---
    networking.networkmanager.enable = true;

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
