{ config, lib, pkgs, ... }:

let
  cfg = config.mySystem.apps.emacs;
in {
  options.mySystem.apps.emacs = {
    enable = lib.mkEnableOption "Emacs and Doom dependencies";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      emacs
      ripgrep
      fd
      git
      pandoc
      shellcheck
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.sauce-code-pro
    ];
  };
}
