{ ... }:

{
  programs.tmux = {
    enable = true;

    keyMode = "vi";
    escapeTime = 0;
    historyLimit = 50000;
    mouse = true;
    focusEvents = true;
    terminal = "tmux-256color";

    extraConfig = ''
      # Allow applications such as Neovim to copy through tmux to the
      # terminal's clipboard via OSC 52.
      set -g set-clipboard on
    '';
  };
}
