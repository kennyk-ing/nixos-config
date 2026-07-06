{ config, lib, pkgs, ... }:

let
  cfg = config.mySystem.apps.emacs;
in {
  options.mySystem.apps.emacs = {
    enable = lib.mkEnableOption "Emacs and Doom dependencies";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      emacs-pgtk
      ripgrep
      fd
      git
      pandoc
      shellcheck

      # Creates a global 'doom' command that points to the current user's local installation
      (writeShellScriptBin "doom" ''
        exec ~/.config/emacs/bin/doom "$@"
      '')
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.sauce-code-pro
    ];

    home-manager.users.kenny = {
      services.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
        client.enable = true;
        defaultEditor = true;
      };
    };
  };
}
