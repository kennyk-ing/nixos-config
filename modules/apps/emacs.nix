{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.apps.emacs;
in
{
  options.mySystem.apps.emacs = {
    enable = lib.mkEnableOption "Emacs and Doom dependencies";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      ripgrep
      fd

      # Doom
      pandoc
      shellcheck

      # Org-roam
      sqlite

      # Spell checking
      (aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          en-science
        ]
      ))
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.sauce-code-pro
      symbola
    ];
  };
}
