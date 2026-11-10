{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.services.systemdFailureAlerts;
in
{
  options.mySystem.services.systemdFailureAlerts = {
    enable = lib.mkEnableOption "systemd failure alerts via Gotify";

    gotify = {
      tokenFile = lib.mkOption {
        type = lib.types.str;
        description = "Path to the Gotify application token.";
      };

      url = lib.mkOption {
        type = lib.types.str;
        default = "https://gotify.home.kinghq.net/message";
        description = "Gotify message API endpoint.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."systemd-failure-alert@" = {
      description = "Gotify alert for failed unit %i";

      scriptArgs = "%i";

      script = ''
        set -euo pipefail

        token="$(${pkgs.coreutils}/bin/cat "$CREDENTIALS_DIRECTORY/token")"

        printf 'header = "X-Gotify-Key: %s"\n' "$token" |
          ${lib.getExe pkgs.curl} --config - \
            --fail --silent --show-error \
            --connect-timeout 3 --max-time 10 \
            --output /dev/null \
            --data-urlencode "title=${config.networking.hostName}: Service failure" \
            --data-urlencode "message=Failed unit: $1.service" \
            --data-urlencode "priority=8" \
            ${lib.escapeShellArg cfg.gotify.url}
      '';

      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        LoadCredential = [ "token:${cfg.gotify.tokenFile}" ];
      };
    };
  };
}
