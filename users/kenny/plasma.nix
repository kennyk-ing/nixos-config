{
  inputs,
  lib,
  osConfig,
  pkgs-unstable,
  ...
}:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    home.packages = with pkgs-unstable; [
      kdePackages.karousel
    ];

    programs.plasma = {
      enable = true;

      # Nine fixed Plasma desktops, arranged vertically.
      # Plasma cannot reproduce Niri's dynamic workspace model.
      kwin.virtualDesktops = {
        number = 9;
        rows = 9;
      };

      # Karousel currently has no first-class plasma-manager module,
      # so enable the KWin script through kwinrc.
      configFile.kwinrc.Plugins.karouselEnabled = true;

      shortcuts = {
        kwin = {
          # ------------------------------------------------------------
          # Karousel: focus
          #
          # Niri:
          #   Meta+H/J/K/L
          #
          # Note:
          # Karousel cannot reproduce Niri's combined
          # focus-window-or-workspace-up/down behavior exactly.
          # ------------------------------------------------------------

          "karousel-focus-left" = "Meta+H";
          "karousel-focus-down" = "Meta+J";
          "karousel-focus-up" = "Meta+K";
          "karousel-focus-right" = "Meta+L";

          # ------------------------------------------------------------
          # Karousel: move columns/windows
          #
          # Niri:
          #   Meta+Shift+H/L -> move whole column
          #   Meta+Shift+J/K -> move window vertically within column
          # ------------------------------------------------------------

          "karousel-column-move-left" = "Meta+Shift+H";
          "karousel-window-move-down" = "Meta+Shift+J";
          "karousel-window-move-up" = "Meta+Shift+K";
          "karousel-column-move-right" = "Meta+Shift+L";

          # ------------------------------------------------------------
          # Karousel: first / last
          # ------------------------------------------------------------

          "karousel-focus-start" = "Meta+Home";
          "karousel-focus-end" = "Meta+End";

          "karousel-column-move-start" = "Meta+Shift+Home";
          "karousel-column-move-end" = "Meta+Shift+End";

          # ------------------------------------------------------------
          # Karousel: consume / expel
          #
          # Moves the focused window into/out of an adjacent column.
          # Closest match to Niri consume/expel.
          # ------------------------------------------------------------

          "karousel-window-move-left" = "Meta+[";
          "karousel-window-move-right" = "Meta+]";

          # ------------------------------------------------------------
          # Karousel: sizing
          # ------------------------------------------------------------

          "karousel-cycle-preset-widths" = "Meta+R";

          "karousel-column-width-decrease" = "Meta+-";
          "karousel-column-width-increase" = "Meta+=";

          # ------------------------------------------------------------
          # Karousel: centering
          #
          # Closest match to Niri center-column.
          # Karousel centers the focused window in the viewport.
          # ------------------------------------------------------------

          "karousel-grid-scroll-focused" = "Meta+C";

          # ------------------------------------------------------------
          # Karousel: layout
          # ------------------------------------------------------------

          "karousel-window-toggle-floating" = "Meta+V";

          # Approximation of Niri's tabbed-column behavior.
          "karousel-column-toggle-stacked" = "Meta+W";

          # ------------------------------------------------------------
          # Native KWin window operations
          # ------------------------------------------------------------

          "Window Close" = "Meta+Q";
          "Window Fullscreen" = "Meta+Ctrl+F";
          "Window Maximize" = "Meta+Ctrl+M";

          # Meta+W belongs to Karousel.
          "Overview" = [ ];

          # ------------------------------------------------------------
          # Virtual desktops
          #
          # Meta+1..9 switches Plasma virtual desktops.
          # ------------------------------------------------------------

          "Switch to Desktop 1" = "Meta+1";
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Switch to Desktop 4" = "Meta+4";
          "Switch to Desktop 5" = "Meta+5";
          "Switch to Desktop 6" = "Meta+6";
          "Switch to Desktop 7" = "Meta+7";
          "Switch to Desktop 8" = "Meta+8";
          "Switch to Desktop 9" = "Meta+9";

          "Switch to Previous Desktop" = "Meta+`";

          # ------------------------------------------------------------
          # Disable Karousel's Meta+1..9 column-focus defaults.
          # ------------------------------------------------------------

          "karousel-focus-1" = [ ];
          "karousel-focus-2" = [ ];
          "karousel-focus-3" = [ ];
          "karousel-focus-4" = [ ];
          "karousel-focus-5" = [ ];
          "karousel-focus-6" = [ ];
          "karousel-focus-7" = [ ];
          "karousel-focus-8" = [ ];
          "karousel-focus-9" = [ ];

          # ------------------------------------------------------------
          # Disable Karousel's Meta+Shift+1..9 window-to-column
          # bindings. We reserve these keys for moving whole columns
          # between Plasma desktops.
          # ------------------------------------------------------------

          "karousel-window-move-to-column-1" = [ ];
          "karousel-window-move-to-column-2" = [ ];
          "karousel-window-move-to-column-3" = [ ];
          "karousel-window-move-to-column-4" = [ ];
          "karousel-window-move-to-column-5" = [ ];
          "karousel-window-move-to-column-6" = [ ];
          "karousel-window-move-to-column-7" = [ ];
          "karousel-window-move-to-column-8" = [ ];
          "karousel-window-move-to-column-9" = [ ];

          # ------------------------------------------------------------
          # Meta+Shift+1..9 -> move whole Karousel column to desktop.
          #
          # Qt/KDE represents shifted US number-row keys using the
          # resulting symbols.
          # ------------------------------------------------------------

          "karousel-column-move-to-desktop-1" = "Meta+!";
          "karousel-column-move-to-desktop-2" = "Meta+@";
          "karousel-column-move-to-desktop-3" = "Meta+#";
          "karousel-column-move-to-desktop-4" = "Meta+$";
          "karousel-column-move-to-desktop-5" = "Meta+%";
          "karousel-column-move-to-desktop-6" = "Meta+^";
          "karousel-column-move-to-desktop-7" = "Meta+&";
          "karousel-column-move-to-desktop-8" = "Meta+*";
          "karousel-column-move-to-desktop-9" = "Meta+(";
        };

        # --------------------------------------------------------------
        # Session / locking
        #
        # Plasma normally uses Meta+L, which conflicts with
        # Karousel focus-right.
        # --------------------------------------------------------------

        ksmserver = {
          "Lock Session" = "Meta+Esc";
        };

        # --------------------------------------------------------------
        # Plasma shell
        # --------------------------------------------------------------

        plasmashell = {
          # Bare Meta opens the application launcher.
          # Keep Alt+F1 as Plasma's normal fallback.
          "activate application launcher" = [
            "Meta"
            "Alt+F1"
          ];

          # Meta+Q belongs to Window Close.
          "manage activities" = [ ];

          # Meta+1..9 belong to virtual desktops.
          "activate task manager entry 1" = [ ];
          "activate task manager entry 2" = [ ];
          "activate task manager entry 3" = [ ];
          "activate task manager entry 4" = [ ];
          "activate task manager entry 5" = [ ];
          "activate task manager entry 6" = [ ];
          "activate task manager entry 7" = [ ];
          "activate task manager entry 8" = [ ];
          "activate task manager entry 9" = [ ];
        };

        # --------------------------------------------------------------
        # Klipper
        #
        # Plasma defaults Meta+V to the clipboard popup.
        # Meta+V belongs to Karousel floating.
        # --------------------------------------------------------------

        klipper = {
          "show-on-mouse-pos" = [ ];
        };

        # --------------------------------------------------------------
        # PowerDevil
        #
        # Plasma defaults Meta+B to cycling the power profile.
        # Meta+B is reserved for your browser launcher.
        # --------------------------------------------------------------

        org_kde_powerdevil = {
          powerProfile = [ ];
        };
      };

      hotkeys.commands = {
        launch-terminal = {
          name = "Launch Terminal";
          key = "Meta+Return";
          command = "ghostty";
        };

        launch-browser = {
          name = "Launch Browser";
          key = "Meta+B";
          command = "zen-beta";
        };

        launch-mail = {
          name = "Launch Thunderbird";
          key = "Meta+E";
          command = "thunderbird";
        };

        launch-files = {
          name = "Launch Dolphin";
          key = "Meta+F";
          command = "dolphin";
        };

        launch-emacs = {
          name = "Launch Emacs";
          key = "Meta+O";
          command = "emacsclient -c -a emacs";
        };
      };
    };
  };
}
