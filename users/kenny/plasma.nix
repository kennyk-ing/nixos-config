{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  pkgs-unstable,
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
    home.packages = [
      pkgs.bibata-cursors
      pkgs.kora-icon-theme
      pkgs.klassy

      pkgs-unstable.kdePackages.karousel
    ];

    programs.plasma = {
      enable = true;

      workspace = {
        # Plasma shell appearance.
        theme = "Carl";
        colorScheme = "Carl";
        widgetStyle = "Breeze";

        # Icons and cursor.
        iconTheme = "kora";
        cursor.theme = "Bibata-Modern-Classic";

        # Klassy decoration to enable active window borders.
        windowDecorations = {
          library = "org.kde.klassy";
          theme = "Klassy";
        };

        # Splash screen disabled.
        splashScreen.theme = "None";

        # Wallpaper slideshow.
        wallpaperSlideShow = {
          path = "${config.home.homeDirectory}/sync/wallpapers/current_favs";
          interval = 1800;
        };
      };

      # Five fixed Plasma desktops, arranged vertically.
      # Plasma cannot reproduce Niri's dynamic workspace model.
      kwin = {
        virtualDesktops = {
          number = 5;
          rows = 5;
        };

        borderlessMaximizedWindows = true;
      };

      # Karousel currently has no first-class plasma-manager module,
      # so enable the KWin script through kwinrc.
      configFile.kwinrc = {
        Plugins.karouselEnabled = true;

        "Script-karousel" = {
          # Window gaps.
          gapsOuterTop = 5;
          gapsOuterBottom = 5;
          gapsOuterLeft = 5;
          gapsOuterRight = 5;

          gapsInnerHorizontal = 5;
          gapsInnerVertical = 5;

          # Niri-like preset width cycle.
          presetWidths = "33%, 50%, 67%";

          # Width/scroll adjustment increments.
          manualScrollStep = 200;
          verticalResizeStep = 32;

          # Closest to Niri's normal scrolling behavior:
          # move the viewport only when necessary.
          scrollingLazy = true;
          scrollingCentered = false;
          scrollingGrouped = false;

          # Normal columns by default; Meta+W toggles stacked mode.
          stackColumnsByDefault = false;

          # Stacked-column visual offset.
          stackOffsetX = 8;
          stackOffsetY = 32;

          # Dragging a tiled window makes it floating.
          untileOnDrag = true;

          # Don't warp the mouse when keyboard focus changes.
          cursorFollowsFocus = false;

          # Keep manual resizing independent rather than resizing the
          # neighboring column in the opposite direction.
          resizeNeighborColumn = false;

          # Don't force restored maximized/fullscreen states on focus.
          reMaximize = false;

          # Keep tiled windows in Alt+Tab.
          skipSwitcher = false;

          # Don't use Karousel's touchpad scrolling yet.
          gestureScroll = false;

          # Fully visible even when partly outside the viewport.
          offScreenOpacity = 100;

          # Karousel's default layering model.
          tiledKeepBelow = true;
          floatingKeepAbove = false;
          noLayering = false;

          # Tile on all Plasma virtual desktops.
          tiledDesktops = ".*";
        };
      };

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

          "karousel-window-toggle-floating" = "Meta+Shift+V";

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
          "Switch One Desktop Down" = "Meta+Ctrl+J";
          "Switch One Desktop Up" = "Meta+Ctrl+K";
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

      window-rules = [
        {
          description = "Default Karousel Width";

          match = {
            window-class = {
              value = ".*";
              type = "regex";
            };

            window-types = [ "normal" ];
          };

          apply.size = {
            value = "952,1050";
            apply = "initially";
          };
        }
      ];

      input.keyboard.options = [
        "caps:ctrl_modifier"
        "shift:both_capslock_cancel"
      ];

      configFile."klassy/klassyrc" = {
        Global = {
          LookAndFeelSet = "Carl";
        };

        Windeco = {
          BoldTitle = false;
          ButtonShape = "ShapeSmallCircle";
          DrawTitleBarSeparator = false;
          IconSize = "IconVerySmall";
        };

        "Windeco Exception 0" = {
          BorderSize = 0;
          Enabled = true;
          ExceptionBorder = false;
          ExceptionMatchTitleBarToApplicationColor = false;
          ExceptionPreset = "";
          ExceptionProgramNamePattern = "";
          ExceptionWindowPropertyPattern = ".*";
          ExceptionWindowPropertyType = 0;
          HideTitleBar = 1;
          OpaqueTitleBar = false;
          PreventApplyOpacityToHeader = false;
        };

        WindowOutlineStyle = {
          WindowOutlineAccentColorOpacityActive = 90;
          WindowOutlineAccentColorOpacityInactive = 20;
          WindowOutlineStyleActive = "WindowOutlineAccentColor";
          WindowOutlineStyleInactive = "WindowOutlineAccentColor";
          WindowOutlineThickness = 3;
        };
      };

      configFile.katerc."KTextEditor View" = {
        "Input Mode" = 1;
        "Vi Input Mode Steal Keys" = true;
        "Vi Relative Line Numbers" = true;
      };

      configFile.kdeglobals.KDE.LookAndFeelPackage = "Carl";

      panels = [
        {
          location = "top";
          height = 20;
          floating = false;
          opacity = "translucent";

          # Normal state after login. Meta toggles this to autohide.
          hiding = "none";

          widgets = [
            {
              kickoff = {
                icon = "nix-snowflake";
                compactDisplayStyle = true;
                favoritesDisplayMode = "list";
                showButtonsFor = "powerAndSession";
                showActionButtonCaptions = false;

                settings.General.switchCategoryOnHover = true;
              };
            }

            "org.kde.plasma.pager"

            {
              panelSpacer.expanding = true;
            }

            {
              applicationTitleBar = {
                layout = {
                  elements = [
                    "windowIcon"
                    "windowTitle"
                  ];

                  verticalAlignment = "bottom";
                };

                windowTitle = {
                  maximumWidth = 800;
                  hideEmptyTitle = true;

                  font = {
                    bold = false;
                    size = 10;
                  };
                };
              };
            }

            {
              panelSpacer.expanding = true;
            }

            "org.kde.plasma.keyboardindicator"

            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.weather"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.networkmanagement"
                ];

                hidden = [
                  "org.kde.plasma.brightness"
                  "org.kde.kscreen"
                  "org.kde.plasma.clipboard"
                ];

                extra = [
                  "org.kde.plasma.cameraindicator"
                  "org.kde.plasma.devicenotifier"
                  "org.kde.plasma.mediacontroller"
                  "org.kde.plasma.notifications"
                  "org.kde.plasma.battery"
                  "org.kde.plasma.keyboardindicator"
                  "org.kde.plasma.printmanager"
                  "org.kde.plasma.volume"
                  "org.kde.plasma.bluetooth"
                  "org.kde.plasma.brightness"
                  "org.kde.kscreen"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.clipboard"
                  "org.kde.plasma.weather"
                ];
              };
            }

            {
              digitalClock.time.format = "12h";
            }
          ];
        }
      ];
    };

    xdg.dataFile = {
      "plasma/desktoptheme/Carl".source = "${inputs.carl-theme}/Carl";

      "color-schemes/Carl.colors".source = "${inputs.carl-theme}/color-schemes/Carl.colors";

      "plasma/look-and-feel/Carl".source = "${inputs.carl-theme}/look-and-feel/Carl";
    };
  };
}
