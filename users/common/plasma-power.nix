{ lib, osConfig, ... }:

{
  config =
    lib.mkIf (osConfig.mySystem.desktop.plasma.enable && osConfig.mySystem.hardware.laptop.enable)
      {
        programs.plasma = {
          enable = true;

          powerdevil = {
            AC = {
              # Dim after 15 minutes.
              dimDisplay.idleTimeout = 900;

              # Turn display off after 30 minutes.
              turnOffDisplay.idleTimeout = 1800;

              # Do not automatically suspend on AC.
              autoSuspend.action = "nothing";

              # Closing the lid turns off the display.
              whenLaptopLidClosed = "turnOffScreen";
            };

            battery = {
              # Dim after 5 minutes.
              dimDisplay.idleTimeout = 300;

              # Turn display off after 10 minutes.
              turnOffDisplay.idleTimeout = 600;

              # power saving mode when on battery
              powerProfile = "powerSaving";
            };

            lowBattery = {
              # If sleeping while in the low-battery profile,
              # use hybrid sleep.
              whenSleepingEnter = "hybridSleep";

              # power saving mode when on battery
              powerProfile = "powerSaving";
            };
          };
        };
      };
}
