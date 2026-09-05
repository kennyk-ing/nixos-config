{
  config,
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    home.packages = [
      pkgs.bibata-cursors
      pkgs.kora-icon-theme
      pkgs.klassy
    ];

    programs.plasma = {
      workspace = {
        theme = "Carl";
        colorScheme = "Carl";
        widgetStyle = "Breeze";

        iconTheme = "kora";
        cursor.theme = "Bibata-Modern-Classic";

        windowDecorations = {
          library = "org.kde.klassy";
          theme = "Klassy";
        };

        splashScreen.theme = "None";

        wallpaperSlideShow = {
          path = "${config.home.homeDirectory}/sync/wallpapers/current_favs";
          interval = 1800;
        };
      };

      configFile = {
        "klassy/klassyrc" = {
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

        kdeglobals.KDE.LookAndFeelPackage = "Carl";
      };
    };

    xdg.dataFile = {
      "plasma/desktoptheme/Carl".source = "${inputs.carl-theme}/Carl";

      "color-schemes/Carl.colors".source = "${inputs.carl-theme}/color-schemes/Carl.colors";

      "plasma/look-and-feel/Carl".source = "${inputs.carl-theme}/look-and-feel/Carl";
    };
  };
}
