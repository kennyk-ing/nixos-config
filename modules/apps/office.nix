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
  };
}
