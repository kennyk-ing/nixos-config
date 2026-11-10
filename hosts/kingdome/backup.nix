{ config, ... }:

{
  age.secrets.restic-server-users = {
    file = ../../secrets/restic-server-users.age;
    owner = "restic";
    group = "restic";
    mode = "0400";
  };

  services.restic.server = {
    enable = true;
    dataDir = "/srv/backups/restic";

    listenAddress = "127.0.0.1:8000";

    htpasswd-file = config.age.secrets.restic-server-users.path;

    appendOnly = true;
    privateRepos = true;
  };

  systemd = {
    services = {
      restic-rest-server.unitConfig = {
        RequiresMountsFor = [ "/srv/backups" ];
        AssertPathIsMountPoint = "/srv/backups";
      };

      # Never run maintenance against an unmounted backup disk.
      restic-backups-tez-apps-check.unitConfig = {
        RequiresMountsFor = [ "/srv/backups" ];
        AssertPathIsMountPoint = "/srv/backups";
      };

      restic-backups-tez-apps-retention.unitConfig = {
        RequiresMountsFor = [ "/srv/backups" ];
        AssertPathIsMountPoint = "/srv/backups";
      };
    };

    sockets.restic-rest-server.unitConfig = {
      RequiresMountsFor = [ "/srv/backups" ];
      AssertPathIsMountPoint = "/srv/backups";
    };
  };

  age.secrets."restic-tez-repository" = {
    file = ../../secrets/restic-tez-repository.age;
    owner = "restic";
    group = "restic";
    mode = "0400";
  };

  services.restic.backups = {
    tez-apps-check = {
      repository = "/srv/backups/restic/tez/apps";
      passwordFile = config.age.secrets."restic-tez-repository".path;
      user = "restic";

      # Maintenance only: no source files to back up.
      paths = [ ];
      runCheck = true;

      timerConfig = {
        OnCalendar = "Sun *-*-* 03:00:00";
        Persistent = true;
      };
    };

    tez-apps-retention = {
      repository = "/srv/backups/restic/tez/apps";
      passwordFile = config.age.secrets."restic-tez-repository".path;
      user = "restic";

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

}
