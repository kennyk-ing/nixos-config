{ config, pkgs, ... }:

{
  home.file.".p10k.zsh".source = ../files/p10k.zsh;

  programs.zsh = {
    enable = true;

    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      nixsw = "nixos-rebuild switch --flake ~/configs/nixos --sudo";
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

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      # create a directory and cd into it
      mdcd() {
        mkdir -p "$@" && cd "$@"
      }

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
