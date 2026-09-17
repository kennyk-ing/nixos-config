{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.services.smartd;

  notifyScript = pkgs.writeShellScript "smartd-gotify" ''
    set -euo pipefail

    curlArgs=(
      --config -
      --connect-timeout 3
      --max-time 10
      --fail
      --silent
      --show-error
      --output /dev/null
      --data-urlencode "title=${config.networking.hostName}: $SMARTD_SUBJECT"
      --data-urlencode "message=$SMARTD_FULLMESSAGE"
      --data-urlencode "priority=8"
      ${lib.escapeShellArg cfg.gotify.url}
    )

    token="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg cfg.gotify.tokenFile})"

    printf 'header = "X-Gotify-Key: %s"\n' "$token" |
      ${lib.getExe pkgs.curl} "''${curlArgs[@]}"
  '';
in
{
  options.mySystem.services.smartd = {
    enable = lib.mkEnableOption "SMART disk monitoring";

    gotify = {
      enable = lib.mkEnableOption "Gotify SMART notifications";

      tokenFile = lib.mkOption {
        type = lib.types.str;
        description = "Path to the Gotify application token.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        description = "Gotify message API endpoint.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.smartmontools
    ];

    services.smartd = {
      enable = true;

      notifications = lib.mkIf cfg.gotify.enable {
        mail.enable = false;
        wall.enable = false;
        x11.enable = false;
      };

      defaults = lib.mkIf cfg.gotify.enable {
        monitored = "-a -m <nomailer> -M exec ${notifyScript}";
        autodetected = "-a";
      };
    };
  };
}
