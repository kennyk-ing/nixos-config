{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mySystem.users.kenny.terminal.enable =
    lib.mkEnableOption "Kenny's graphical terminal setup";

  config =
    lib.mkIf (config.mySystem.users.kenny.enable && config.mySystem.users.kenny.terminal.enable)
      {
        home-manager.users.kenny = {
          home.packages = with pkgs; [
            fira
            nerd-fonts.sauce-code-pro
          ];
          fonts.fontconfig.enable = true;
          programs = {
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
          xdg.terminal-exec = {
            enable = true;
            settings.default = [ "kitty.desktop" ];
          };
        };
      };
}
