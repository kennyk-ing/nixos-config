{ ... }:

{
  programs.tmux = {
    enable = true;

    prefix = "C-a";

    keyMode = "vi";
    historyLimit = 50000;

    mouse = true;
    focusEvents = true;
    aggressiveResize = true;

    terminal = "tmux-256color";

    # Number windows and panes from 1.
    baseIndex = 1;

    # Prefix + h/j/k/l moves between panes.
    # Prefix + H/J/K/L resizes panes.
    customPaneNavigationAndResize = true;
    resizeAmount = 2;

    extraConfig = ''
      # Close numbering gaps when windows are removed.
      set -g renumber-windows on

      # Allow applications such as Neovim to copy through tmux to the
      # terminal clipboard using OSC 52.
      set -g set-clipboard on

      # Reload the Home Manager-generated tmux configuration.
      bind -N "Reload tmux configuration" r \
        source-file ~/.config/tmux/tmux.conf \; \
        display-message "Reloaded tmux configuration"

      # Convenient pane splits that retain the current working directory.
      bind -N "Split pane left/right" '|' \
        split-window -h -c "#{pane_current_path}"

      bind -N "Split pane top/bottom" '-' \
        split-window -v -c "#{pane_current_path}"

      ${builtins.readFile ./carbonfox.tmux}
    '';
  };
}
