{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.mySystem.apps.emacs.enable {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
  };

  xdg.configFile."emacs".source = inputs.doom-emacs;

  home = {
    sessionPath = [
      "$HOME/.config/emacs/bin"
    ];

    sessionVariables.DOOMLOCALDIR = "${config.xdg.dataHome}/doom";

    file.".aspell.conf".text = ''
      master en_US
      extra-dicts en-computers.rws
      add-extra-dicts en_US-science.rws
      add-extra-dicts en-medical.rws
    '';
  };
}
