{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.kenny.workstation;
in
{
  imports = [
    ./codex.nix
  ];

  options.mySystem.users.kenny.workstation = {
    enable = lib.mkEnableOption "Kenny's Graphical Workstation Additions";
  };

  config = lib.mkIf cfg.enable {
    users.users.kenny.extraGroups = [ "networkmanager" ];

    mySystem.apps.emacs.enable = true;

    home-manager.users."kenny" = {
      imports = [
        ./apps/browsers.nix
        ./apps/emacs.nix
        ./apps/nixvim
        ./apps/thunderbird.nix
        ./plasma
      ];

      home.packages = with pkgs; [
        anki
        kdePackages.kate
        fira
        nerd-fonts.sauce-code-pro
        virt-viewer
      ];

      # Shared by tez and woo; only installed when Niri is enabled.
      xdg.configFile = lib.mkIf config.mySystem.desktop.niri.enable {
        "niri" = {
          source = ../../modules/desktop/niri/configs;
          recursive = true;
        };
        "noctalia/config.toml".source = ./files/noctalia.toml;
      };

      # Make sure home manager can install fonts to the system catalog
      fonts.fontconfig.enable = true;

      programs = {
        obsidian = {
          enable = true;
        };

        calibre = {
          enable = true;
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        kitty = {
          enable = true;
          shellIntegration.enableZshIntegration = true;

          themeFile = "Carbonfox";

          settings = {
            font_family = "SauceCodePro Nerd Font";
            font_size = 12.0;
            background = "#000000";
            background_opacity = 0.90;
          };
        };
      };

      xdg = {
        terminal-exec = {
          enable = true;
          settings.default = [
            "kitty.desktop"
          ];
        };
      };
    };
  };
}
