# Carbonfox theme for tmux.
# Adapted from:
# https://github.com/EdenEast/nightfox.nvim/blob/main/extra/carbonfox/carbonfox.tmux

set -g mode-style "fg=#0c0c0c,bg=#b6b8bb"
set -g message-style "fg=#0c0c0c,bg=#b6b8bb"
set -g message-command-style "fg=#0c0c0c,bg=#b6b8bb"

set -g pane-border-style "fg=#b6b8bb"
set -g pane-active-border-style "fg=#78a9ff"

set -g status on
set -g status-justify left
set -g status-style "fg=#b6b8bb,bg=#0c0c0c"
set -g status-left-length 100
set -g status-right-length 100

set -g status-left \
  "#[fg=#0c0c0c,bg=#78a9ff,bold] #{session_name} #[fg=#78a9ff,bg=#0c0c0c,nobold]"

set -g status-right \
  "#[fg=#78a9ff,bg=#0c0c0c,bold]#{?client_prefix, PREFIX ,}#[fg=#b6b8bb,bg=#0c0c0c,nobold]#[fg=#0c0c0c,bg=#b6b8bb] %Y-%m-%d  %I:%M %p #[fg=#78a9ff,bg=#b6b8bb]#[fg=#0c0c0c,bg=#78a9ff,bold] #{host_short} "

setw -g window-status-activity-style \
  "underscore,fg=#7b7c7e,bg=#0c0c0c"

setw -g window-status-separator ""

setw -g window-status-style \
  "NONE,fg=#7b7c7e,bg=#0c0c0c"

setw -g window-status-format \
  "#[fg=#0c0c0c,bg=#0c0c0c]#[default] #{window_index}  #{window_name} #{window_flags} #[fg=#0c0c0c,bg=#0c0c0c]"

setw -g window-status-current-format \
  "#[fg=#0c0c0c,bg=#b6b8bb]#[fg=#0c0c0c,bg=#b6b8bb,bold] #{window_index}  #{window_name} #{window_flags} #[fg=#b6b8bb,bg=#0c0c0c,nobold]"

