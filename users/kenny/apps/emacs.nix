{
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

  home = {
    sessionPath = [
      "$HOME/.config/emacs/bin"
    ];

    file.".aspell.conf".text = ''
      master en_US
      extra-dicts en-computers.rws
      add-extra-dicts en_US-science.rws
    '';
  };
}
