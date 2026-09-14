{ lib, osConfig, ... }:

{
  imports = [
    ./appearance.nix
    ./window-management.nix
    ./shortcuts.nix
    ./panel.nix
  ];

  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    programs.plasma = {
      enable = true;

      input.keyboard.options = [
        "caps:ctrl_modifier"
        "shift:both_capslock_cancel"
      ];

      configFile.katerc."KTextEditor View" = {
        "Input Mode" = 1;
        "Vi Input Mode Steal Keys" = true;
        "Vi Relative Line Numbers" = true;
      };
    };
  };
}
