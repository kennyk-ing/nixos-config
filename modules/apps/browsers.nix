{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.mySystem.apps.browsers;
in
  {
  options.mySystem.apps.browsers = {
    enable = lib.mkEnableOption "My collection of Web Browsers";
  };

  config = lib.mkIf cfg.enable {
    # --- Firefox ---
    programs.firefox = {
      enable = true;
      preferences = {
        # Hardware Acceleration (VA-API)
        "media.ffmpeg.vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        # UI Performance Fixes (Wayland lag fix)
        "accessibility.force_disabled" = 1;
        "general.smoothScroll" = true;
      };
    };

    # --- Environment Variables ---
    # Ensures all Mozilla-based browsers (Firefox, LibreWolf, Zen) default to Wayland
    environment.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };

    # --- Additional Browsers ---
    environment.systemPackages = with pkgs; [
      # LibreWolf: Privacy-hardened Firefox
      librewolf

      # Ungoogled Chromium: Native Wayland Overrides
      (ungoogled-chromium.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--enable-wayland-ime" # Improves text input compatibility on Wayland
          "--ignore-gpu-blocklist" # Forces GPU acceleration
          "--enable-gpu-rasterization"
          "--enable-zero-copy"
        ];
      })

      # Zen Browser
      (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        extraPolicies = {
          DisableAppUpdate = true; # Highly recommended: lets Nix manage updates instead of the browser
          Preferences = {
            # --- UI Performance Fixes (Wayland lag fix) ---
            "accessibility.force_disabled" = { Value = 1; Status = "locked"; };

            # --- Hardware Acceleration (VA-API) ---
            "media.ffmpeg.vaapi.enabled" = { Value = true; Status = "locked"; };
            "gfx.webrender.all" = { Value = true; Status = "locked"; };
          };
        };
      })


    ];

    home-manager.users.kenny = {
      # Set default browser
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = "zen-beta.desktop";
          "application/xhtml+xml" = "zen-beta.desktop";
          "application/x-extension-htm" = "zen-beta.desktop";
          "application/x-extension-html" = "zen-beta.desktop";
          "application/x-extension-shtml" = "zen-beta.desktop";
          "application/x-extension-xhtml" = "zen-beta.desktop";
          "application/x-extension-xht" = "zen-beta.desktop";
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/chrome" = "zen-beta.desktop";
        };
      };
    };
  };
}
