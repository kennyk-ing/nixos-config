{ ... }:

{
  # Disable the DE-specific power manager
  services.power-profiles-daemon.enable = false;

  # Enable TLP (Universal power management)
  services.tlp = {
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
  services.thermald.enable = true;
}
