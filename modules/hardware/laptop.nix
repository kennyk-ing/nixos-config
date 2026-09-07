{ lib, config, ... }:
let
  cfg = config.mySystem.hardware.laptop;
in
{
  options.mySystem.hardware.laptop = {
    enable = lib.mkEnableOption "Laptop-specific system configuration";
  };

  config = lib.mkIf cfg.enable {
    mySystem.hardware.tplink-ethernet2usb.enable = true;

    # If openssh and tailscale are both enabled:
    # open port 22 on the tailscale interface only
    networking.firewall.interfaces.tailscale0.allowedTCPPorts = lib.optionals (
      config.mySystem.services.openssh.enable && config.mySystem.services.tailscale.enable
    ) [ 22 ];

    services = {
      # TLP owns system power-profile policy, so do not also run
      # power-profiles-daemon.
      power-profiles-daemon.enable = lib.mkForce false;

      # Enable TLP (Universal power management)
      tlp = {
        enable = true;

        # Expose TLPs profiles through the standard desktop API
        pd.enable = true;

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
    };
  };
}
