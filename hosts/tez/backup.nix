{ config, pkgs, ... }:

{
  age.secrets."restic-tez-http".file = ../../secrets/restic-tez-http.age;
  age.secrets."restic-tez-repository".file = ../../secrets/restic-tez-repository.age;

  services.restic.backups.tez-apps = {
    repository = "rest:https://backups.home.kinghq.net/tez/apps/";
    environmentFile = config.age.secrets."restic-tez-http".path;
    passwordFile = config.age.secrets."restic-tez-repository".path;
    initialize = false;

    paths = [
      "/var/lib/restic-tez-apps"
      "/var/lib/sonarr/.config/NzbDrone/Backups"
      "/var/lib/radarr/.config/Radarr/Backups"
      "/var/lib/bazarr/backup"
      "/var/lib/private/prowlarr/Backups"
      "/var/lib/private/seerr"
      "/var/lib/private/open-webui"
      "/var/lib/plex/Plex Media Server"
      "/var/lib/nixos-containers/torrent/var/lib/qBittorrent/qBittorrent"
    ];

    exclude = [
      # Plex cache and other stuff we don't need to save
      "/var/lib/plex/Plex Media Server/Cache"
      "/var/lib/plex/Plex Media Server/Logs"
      "/var/lib/plex/Plex Media Server/Codecs"

      # Active databases: use Plex's dated backup copies instead.
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db"
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db-wal"
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.db-shm"
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.blobs.db"
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.blobs.db-wal"
      "/var/lib/plex/Plex Media Server/Plug-in Support/Databases/com.plexapp.plugins.library.blobs.db-shm"

      # Live SQLite files: use the consistent copies instead.
      "/var/lib/private/seerr/db/db.sqlite3*"
      "/var/lib/private/open-webui/data/webui.db*"
      "/var/lib/private/open-webui/data/vector_db/chroma.sqlite3*"

      # Open WebUI caches and models.
      "/var/lib/private/open-webui/transformers_home"
      "/var/lib/private/open-webui/hf_home"
      "/var/lib/private/open-webui/data/cache"

      # qBittorrent logs
      "/var/lib/nixos-containers/torrent/var/lib/qBittorrent/qBittorrent/data/logs"
    ];

    timerConfig = {
      OnCalendar = "*-*-* 06:30:00";
      Persistent = true;
    };

    backupPrepareCommand = ''
      #!${pkgs.runtimeShell}
      set -eu

      ${pkgs.coreutils}/bin/install -d -m 0700 /var/lib/restic-tez-apps

      ${pkgs.sqlite}/bin/sqlite3 -bail -readonly \
        /var/lib/private/seerr/db/db.sqlite3 \
        ".backup '/var/lib/restic-tez-apps/seerr.db'"

      ${pkgs.sqlite}/bin/sqlite3 -bail -readonly \
        /var/lib/private/open-webui/data/webui.db \
        ".backup '/var/lib/restic-tez-apps/webui.db'"

      ${pkgs.sqlite}/bin/sqlite3 -bail -readonly \
        /var/lib/private/open-webui/data/vector_db/chroma.sqlite3 \
        ".backup '/var/lib/restic-tez-apps/chroma.sqlite3'"
    '';

    # Retention will be handled on the backup server.
    pruneOpts = [ ];

    # Integrity checks will be configured separately.
    runCheck = false;
  };
}
