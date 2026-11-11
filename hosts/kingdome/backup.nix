{ config, pkgs, ... }:
let
  keys = import ../../keys.nix;
in
{
  age.secrets = {
    restic-server-users = {
      file = ../../secrets/restic-server-users.age;
      owner = "restic";
      group = "restic";
      mode = "0400";
    };

    "restic-tez-repository" = {
      file = ../../secrets/restic-tez-repository.age;
      owner = "restic";
      group = "restic";
      mode = "0400";
    };

    "restic-kingdome-ssh" = {
      file = ../../secrets/restic-kingdome-ssh.age;
      mode = "0400";
    };

    "restic-kingdome-repository" = {
      file = ../../secrets/restic-kingdome-repository.age;
      mode = "0400";
    };
  };

  programs.ssh.knownHosts."kam.home.kinghq.net".publicKey = keys.hosts.kam;

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

        OnFailure = [ "systemd-failure-alert@%N.service" ];
      };

      restic-backups-tez-apps-retention.unitConfig = {
        RequiresMountsFor = [ "/srv/backups" ];
        AssertPathIsMountPoint = "/srv/backups";

        OnFailure = [ "systemd-failure-alert@%N.service" ];
      };

      restic-backups-kingdome-apps.unitConfig.OnFailure = [
        "systemd-failure-alert@%N.service"
      ];
    };

    sockets.restic-rest-server.unitConfig = {
      RequiresMountsFor = [ "/srv/backups" ];
      AssertPathIsMountPoint = "/srv/backups";
    };
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

    kingdome-apps = {
      repository = "sftp:restic-kingdome@kam.home.kinghq.net:/kingdome/apps";

      passwordFile = config.age.secrets."restic-kingdome-repository".path;

      extraOptions = [
        "sftp.args='-i /run/agenix/restic-kingdome-ssh -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o BatchMode=yes'"
      ];

      initialize = false;

      paths = [
        "/var/lib/restic-kingdome-apps"
        "/var/lib/private/gotify-server/data"
        "/var/lib/plexpy/backups"
        "/var/lib/plexpy/config.ini"
        "/var/lib/plexpy/newsletters"
      ];

      exclude = [
        "/var/lib/private/gotify-server/data/gotify.db*"
      ];

      backupPrepareCommand = ''
        #!${pkgs.runtimeShell}
        set -eu

        ${pkgs.coreutils}/bin/install -d -m 0700 /var/lib/restic-kingdome-apps

        ${pkgs.sqlite}/bin/sqlite3 -bail -readonly \
          /var/lib/private/gotify-server/data/gotify.db \
          ".backup '/var/lib/restic-kingdome-apps/gotify.db'"
      '';

      timerConfig = {
        OnCalendar = "*-*-* 06:45:00";
        Persistent = true;
      };

      pruneOpts = [ ];
      runCheck = false;
    };
  };

}
