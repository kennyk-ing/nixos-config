{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

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
    };

    # --- Additional Browsers ---
    environment.systemPackages = with pkgs; [
      # LibreWolf: Privacy-hardened Firefox
      librewolf

      # Ungoogled Chromium: Native Wayland Overrides
      (ungoogled-chromium.override {
        enableWideVine = true;
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--enable-wayland-ime" # Improves text input compatibility on Wayland
        ];
      })

      # Zen Browser
      (inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        extraPolicies = {
          DisableAppUpdate = true; # Highly recommended: lets Nix manage updates instead of the browser
        };
      })

    ];
  };
}
