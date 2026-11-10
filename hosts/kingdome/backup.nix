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

  systemd.services.restic-rest-server.unitConfig = {
    RequiresMountsFor = [ "/srv/backups" ];
    AssertPathIsMountPoint = "/srv/backups";
  };

  systemd.sockets.restic-rest-server.unitConfig = {
    RequiresMountsFor = [ "/srv/backups" ];
    AssertPathIsMountPoint = "/srv/backups";
  };
}
