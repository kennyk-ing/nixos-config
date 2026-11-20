{ config, ... }:

{
  age.secrets."kavita-token".file = ../../secrets/kavita-token.age;

  users = {
    groups.media.gid = 2000;

    users = {
      audiobookshelf.extraGroups = [ "media" ];
      kavita.extraGroups = [ "media" ];
    };
  };

  # Enable NFS filesystem support.
  boot.supportedFilesystems = [ "nfs" ];

  # remote media files
  fileSystems."/srv/books" = {
    device = "tez.home.kinghq.net:/srv/storage/hdd1/books";
    fsType = "nfs4";
    options = [
      "ro"
      "_netdev"
      "nofail"
      "x-systemd.mount-timeout=30s"
    ];
  };

  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0";
    port = 8000;
    openFirewall = false;
  };

  services.kavita = {
    enable = true;
    tokenKeyFile = config.age.secrets."kavita-token".path;

    settings = {
      IpAddresses = "0.0.0.0";
      Port = 5000;
      KnownProxies = [ "10.0.10.2" ];
    };
  };

  systemd.services = {
    audiobookshelf = {
      # Do not launch against an unavailable library mount.
      unitConfig.RequiresMountsFor = [ "/srv/books" ];
      unitConfig.OnFailure = [
        "systemd-failure-alert@%N.service"
      ];
    };

    kavita = {
      unitConfig.RequiresMountsFor = [ "/srv/books" ];
      unitConfig.OnFailure = [
        "systemd-failure-alert@%N.service"
      ];
    };
  };
}
