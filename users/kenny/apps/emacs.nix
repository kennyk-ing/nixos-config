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

  services.emacs = {
    enable = true;
    client.enable = true;

    defaultEditor = false;
  };
}
