{ config, ... }:

{
  age.secrets = {
    "restic-kingdome-repository" = {
      file = ../../secrets/restic-kingdome-repository.age;
      owner = "restic-kingdome";
      group = "restic-kingdome";
      mode = "0400";
    };

    "gotify-backups-token".file = ../../secrets/gotify-backups-token.age;
  };

  mySystem.services.systemdFailureAlerts = {
    enable = true;
    gotify.tokenFile = config.age.secrets."gotify-backups-token".path;
  };

  services.restic.backups = {
    kingdome-apps-check = {
      repository = "/srv/backups/kingdome/apps";
      passwordFile = config.age.secrets."restic-kingdome-repository".path;
      user = "restic-kingdome";

      # Maintenance only: no source files to back up.
      paths = [ ];
      runCheck = true;
      checkOpts = [ "--read-data" ];

      timerConfig = {
        OnCalendar = "Sun *-*-* 03:00:00";
        Persistent = true;
      };
    };

    kingdome-apps-retention = {
      repository = "/srv/backups/kingdome/apps";
      passwordFile = config.age.secrets."restic-kingdome-repository".path;
      user = "restic-kingdome";

      paths = [ ];

      pruneOpts = [
        "--keep-within 90d"
        "--keep-within-monthly 1y"
        "--group-by host"
      ];

      # Verify the repository after pruning.
      runCheck = true;

      timerConfig = {
        OnCalendar = "*-*-01 04:00:00";
        Persistent = true;
      };
    };
  };

  systemd.services = {
    restic-backups-kingdome-apps-check.unitConfig.OnFailure = [
      "systemd-failure-alert@%N.service"
    ];

    restic-backups-kingdome-apps-retention.unitConfig.OnFailure = [
      "systemd-failure-alert@%N.service"
    ];
  };

  users.groups.restic-kingdome = { };

  users.users.restic-kingdome = {
    isSystemUser = true;
    group = "restic-kingdome";
    home = "/";
    createHome = false;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEyd0UuW7sYjtOqUmzQpxgIJx7ZeEEwkJ9lHz+60EYW4 restic-kingdome-to-kam"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/backups 0755 root root - -"
    "d /srv/backups/kingdome 0700 restic-kingdome restic-kingdome - -"
  ];

  services.openssh.extraConfig = ''
    Match User restic-kingdome
      ChrootDirectory /srv/backups
      ForceCommand internal-sftp -d /kingdome
      DisableForwarding yes
      PermitTTY no

    Match all
  '';
}
