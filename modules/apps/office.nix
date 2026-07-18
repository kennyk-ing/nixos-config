{ config, lib, pkgs, ... }:

let
  cfg = config.mySystem.apps.office;
in {
  options.mySystem.apps.office = {
    enable = lib.mkEnableOption "OnlyOffice Suite with Microsoft Fonts";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.onlyoffice-desktopeditors
    ];

    fonts = {
      packages = [
        pkgs.corefonts
        pkgs.vista-fonts # Provides Calibri and Cambria
      ];
    };

    # Workaround for ONLYOFFICE failing to read Nix store symlinks
    system.userActivationScripts.onlyofficeFonts = {
      text = ''
        # Create a dedicated, non-symlinked local font directory
        mkdir -p ~/.local/share/fonts/onlyoffice
        rm -f ~/.local/share/fonts/onlyoffice/*

        # Recursively find and copy the raw .ttf files, dereferencing (-L) the symlinks
        find ${pkgs.corefonts}/share/fonts -type f -iname "*.ttf" -exec cp -L {} ~/.local/share/fonts/onlyoffice/ \;
        find ${pkgs.vista-fonts}/share/fonts -type f -iname "*.ttf" -exec cp -L {} ~/.local/share/fonts/onlyoffice/ \;

        # Fix permissions so ONLYOFFICE is allowed to read the local copies
        chmod 644 ~/.local/share/fonts/onlyoffice/* 2>/dev/null || true
      '';
    };
  };
}
