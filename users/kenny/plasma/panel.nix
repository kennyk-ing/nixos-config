{ lib, osConfig, ... }:

{
  config = lib.mkIf osConfig.mySystem.desktop.plasma.enable {
    programs.plasma.panels = [
      {
        location = "top";
        height = 20;
        floating = false;
        opacity = "translucent";

        # Meta toggles this to autohide at runtime.
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
}
