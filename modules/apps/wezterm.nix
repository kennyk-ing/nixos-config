{ config, lib, ... }:

let
  cfg = config.mySystem.apps.wezterm;
in
{
  options.mySystem.apps.wezterm = {
    enable = lib.mkEnableOption "WezTerm terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.kenny = {
      programs.wezterm = {
        enable = true;
        extraConfig = builtins.readFile ./files/wezterm.lua;
      };
    };
  };
}
