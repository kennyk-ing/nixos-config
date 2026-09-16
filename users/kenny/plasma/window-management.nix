{
  lib,
  osConfig,
  pkgs-unstable,
  ...
}:
let
  isTez = osConfig.networking.hostName == "tez";
in
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

        effects.zoom.enable = false;
      };

      configFile.kwinrc = {
        # Disable top left hot corner overview
        "Effect-overview".BorderActivate = 9;

        # Karousel currently has no first-class plasma-manager module.
        Plugins.karouselEnabled = true;
        "Script-karousel" = {
          # Gaps.
          gapsOuterTop = if isTez then 8 else 5;
          gapsOuterBottom = if isTez then 8 else 5;
          gapsOuterLeft = if isTez then 8 else 5;
          gapsOuterRight = if isTez then 8 else 5;

          gapsInnerHorizontal = if isTez then 20 else 5;
          gapsInnerVertical = if isTez then 12 else 5;

          # Column sizing.
          presetWidths = "33%, 50%, 67%, 100%";
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
            value = if isTez then "1262,1050" else "952,1050";
            apply = "initially";
          };
        }
      ];
    };
  };
}
