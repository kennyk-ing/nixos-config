{ lib, config, ... }:

let
  cfg = config.mySystem.apps.firefox;
in
{
  options.mySystem.apps.firefox = {
    enable = lib.mkEnableOption "Firefox Web Browser";
  };

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;

      preferences = {
        # --- Hardware Acceleration (VA-API) ---
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;

        # --- UI Performance Fixes ---
        # Disables accessibility services to fix extreme typing/UI lag on Wayland
        "accessibility.force_disabled" = 1;

        "general.smoothScroll" = true;
      };
    };
  };
}
