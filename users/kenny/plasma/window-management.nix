{
  lib,
  osConfig,
  pkgs-unstable,
  ...
}:

{
  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    home.packages = [
      pkgs-unstable.kdePackages.karousel
    ];

    programs.plasma = {
      kwin = {
        virtualDesktops = {
          number = 5;
          rows = 5;
        };

        borderlessMaximizedWindows = true;
      };

      # Karousel currently has no first-class plasma-manager module.
      configFile.kwinrc = {
        Plugins.karouselEnabled = true;

        "Script-karousel" = {
          # Gaps.
          gapsOuterTop = 5;
          gapsOuterBottom = 5;
          gapsOuterLeft = 5;
          gapsOuterRight = 5;
          gapsInnerHorizontal = 5;
          gapsInnerVertical = 5;

          # Column sizing.
          presetWidths = "33%, 50%, 67%";
          manualScrollStep = 200;
          verticalResizeStep = 32;

          # Scrolling.
          scrollingLazy = true;
          scrollingCentered = false;
          scrollingGrouped = false;

          # Stacked columns.
          stackColumnsByDefault = false;
          stackOffsetX = 8;
          stackOffsetY = 32;

          # Window behavior.
          untileOnDrag = true;
          cursorFollowsFocus = false;
          resizeNeighborColumn = false;
          reMaximize = false;
          skipSwitcher = false;

          # Touchpad gestures.
          gestureScroll = false;

          # Off-screen windows.
          offScreenOpacity = 100;

          # Layering.
          tiledKeepBelow = true;
          floatingKeepAbove = false;
          noLayering = false;

          # Tile on every virtual desktop.
          tiledDesktops = ".*";
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
    };
  };
}
