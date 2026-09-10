{ config, lib, ... }:

let
  cfg = config.mySystem.profiles.server;
in
{
  options.mySystem.profiles.server = {
    enable = lib.mkEnableOption "server system profile";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.mySystem.profiles.workstation.enable;
        message = "The server and workstation profiles are mutually exclusive.";
      }
      {
        assertion = !config.networking.networkmanager.enable;
        message = "The server profile uses systemd-networkd, not NetworkManager.";
      }
    ];

    networking = {
      enableIPv6 = false;
      useDHCP = false;
    };
    systemd.network.enable = true;
  };
}
