{
  lib,
  osConfig,
  pkgs,
  ...
}:

let
  togglePlasmaPanel = pkgs.writeShellApplication {
    name = "toggle-plasma-panel";

    runtimeInputs = [
      pkgs.kdePackages.qttools
      pkgs.coreutils
    ];

    text = ''
      qdbus org.kde.plasmashell \
        /PlasmaShell \
        org.kde.PlasmaShell.evaluateScript \
        "const ps = panels(); for (let i = 0; i < ps.length; ++i) { if (ps[i].location === 'top') { ps[i].hiding = ps[i].hiding === 'autohide' ? 'none' : 'autohide'; break; } }"

      # Give KWin time to update the available work area before
      # forcing Karousel to recalculate its layout.
      sleep 0.15

      qdbus org.kde.kglobalaccel \
        /component/kwin \
        invokeShortcut \
        karousel-screen-switch
    '';
  };
in
{
  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    programs.plasma = {
      shortcuts = {
        kwin = {
          # Karousel: focus.
          "karousel-focus-left" = "Meta+H";
          "karousel-focus-down" = "Meta+J";
          "karousel-focus-up" = "Meta+K";
          "karousel-focus-right" = "Meta+L";

          # Karousel: move columns/windows.
          "karousel-column-move-left" = "Meta+Shift+H";
          "karousel-window-move-down" = "Meta+Shift+J";
          "karousel-window-move-up" = "Meta+Shift+K";
          "karousel-column-move-right" = "Meta+Shift+L";

          # Karousel: first/last.
          "karousel-focus-start" = "Meta+Home";
          "karousel-focus-end" = "Meta+End";
          "karousel-column-move-start" = "Meta+Shift+Home";
          "karousel-column-move-end" = "Meta+Shift+End";

          # Karousel: consume/expel.
          "karousel-window-move-left" = "Meta+[";
          "karousel-window-move-right" = "Meta+]";

          # Karousel: sizing/centering.
          "karousel-cycle-preset-widths" = "Meta+R";
          "karousel-column-width-decrease" = "Meta+-";
          "karousel-column-width-increase" = "Meta+=";
          "karousel-grid-scroll-focused" = "Meta+C";

          # Karousel: layout.
          "karousel-window-toggle-floating" = "Meta+Shift+V";
          "karousel-column-toggle-stacked" = "Meta+W";

          # Native KWin operations.
          "Window Close" = "Meta+Q";
          "Window Fullscreen" = "Meta+Ctrl+F";
          "Window Maximize" = "Meta+Ctrl+M";

          # Meta+W belongs to Karousel.
          "Overview" = [ ];

          # Virtual desktops.
          "Switch to Desktop 1" = "Meta+1";
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Switch to Desktop 4" = "Meta+4";
          "Switch to Desktop 5" = "Meta+5";

          "Switch to Desktop 6" = [ ];
          "Switch to Desktop 7" = [ ];
          "Switch to Desktop 8" = [ ];
          "Switch to Desktop 9" = [ ];

          "Switch One Desktop Down" = "Meta+Ctrl+J";
          "Switch One Desktop Up" = "Meta+Ctrl+K";
          "Switch to Previous Desktop" = "Meta+`";

          # Reserve Meta+1..9 for Plasma virtual desktops.
          "karousel-focus-1" = [ ];
          "karousel-focus-2" = [ ];
          "karousel-focus-3" = [ ];
          "karousel-focus-4" = [ ];
          "karousel-focus-5" = [ ];
          "karousel-focus-6" = [ ];
          "karousel-focus-7" = [ ];
          "karousel-focus-8" = [ ];
          "karousel-focus-9" = [ ];

          # Reserve Meta+Shift+1..9 for moving whole columns between
          # Plasma virtual desktops.
          "karousel-window-move-to-column-1" = [ ];
          "karousel-window-move-to-column-2" = [ ];
          "karousel-window-move-to-column-3" = [ ];
          "karousel-window-move-to-column-4" = [ ];
          "karousel-window-move-to-column-5" = [ ];
          "karousel-window-move-to-column-6" = [ ];
          "karousel-window-move-to-column-7" = [ ];
          "karousel-window-move-to-column-8" = [ ];
          "karousel-window-move-to-column-9" = [ ];

          # Move whole Karousel columns between desktops.
          "karousel-column-move-to-desktop-1" = "Meta+!";
          "karousel-column-move-to-desktop-2" = "Meta+@";
          "karousel-column-move-to-desktop-3" = "Meta+#";
          "karousel-column-move-to-desktop-4" = "Meta+$";
          "karousel-column-move-to-desktop-5" = "Meta+%";

          "karousel-column-move-to-desktop-6" = [ ];
          "karousel-column-move-to-desktop-7" = [ ];
          "karousel-column-move-to-desktop-8" = [ ];
          "karousel-column-move-to-desktop-9" = [ ];
        };

        # Meta+L belongs to Karousel focus-right.
        ksmserver."Lock Session" = "Meta+Esc";

        plasmashell = {
          # Application launcher.
          "activate application launcher" = [
            "Meta+Space"
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

        # Meta+V launches Neovim.
        klipper."show-on-mouse-pos" = [ ];

        # Meta+B launches the browser.
        org_kde_powerdevil.powerProfile = [ ];

        # Keep Plasma's old KRunner shortcut disabled.
        krunner."run command" = [ ];
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

        launch-obsidian = {
          name = "Launch Obsidian";
          key = "Meta+O";
          command = "obsidian";
        };

        launch-nvim = {
          name = "Launch Neovim";
          key = "Meta+V";
          command = "xdg-terminal-exec nvim";
        };

        toggle-panel = {
          name = "Toggle Plasma Panel";
          key = "Meta";
          command = "${togglePlasmaPanel}/bin/toggle-plasma-panel";
        };
      };
    };
  };
}
