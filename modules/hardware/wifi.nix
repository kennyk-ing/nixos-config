{ lib, config, ... }:

let
  cfg = config.mySystem.hardware.wifi;
in {
  options.mySystem.hardware.wifi = {
    enable = lib.mkEnableOption "Wifi Networking";
  };

  config = lib.mkIf cfg.enable {
    age.secrets.wifi.file = ../../secrets/wifi.age;

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [ config.age.secrets.wifi.path ];
      profiles = {
        "HomeNetwork" = {
          connection = {
            id = "HomeNetwork";
            type = "wifi";
          };
          wifi = {
            ssid = "$HOME_WIFI_SSID";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$HOME_WIFI_PSK";
          };
        };
      };
    };
  };
}
