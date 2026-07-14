{ config, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
    };
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    autocd = true;
    history = {
      append = true;
      ignoreAllDups = true;
      save = 50000;
      size = 50000;
    };
    historySubstringSearch.enable = true;
    defaultKeymap = "viins"; # vi mode
    antidote = {
      enable = true;
      useFriendlyNames = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
      ];
    };
    initContent = ''
      # create a directory and cd into it
      mdcd() {
        mkdir -p "$@" && cd "$@"
      }
    '';
  };
}
