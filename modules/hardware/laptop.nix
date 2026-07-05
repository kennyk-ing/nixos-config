{ lib, config, ... }:
let
  cfg = config.mySystem.hardware.laptop;
in
{
  options.mySystem.hardware.laptop = {
    enable = lib.mkEnableOption "Laptop Power Management Features";
  };

  config = lib.mkIf cfg.enable {
    services = {
      # Disable the DE-specific power manager
      power-profiles-daemon.enable = lib.mkForce false;

      # Enable TLP (Universal power management)
      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          # Useful if you leave your laptop plugged in all the time
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 80;
        };
      };

      # prevent overheating
      thermald.enable = true;

      # prevent system from going to sleep on logout
      logind = {
        settings.Login = {
          HandleLidSwitchExternalPower = "ignore";
          HandleLidSwitchDocked = "ignore";
        };
      };
    };

  };
}
