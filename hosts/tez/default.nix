{ config, ... }:

{
  imports = [
    ./ai.nix
    ./backup.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./servarr.nix
    ./storage.nix
    ./torrent.nix
  ];

  age.secrets."gotify-backups-token".file = ../../secrets/gotify-backups-token.age;
  networking.hostName = "tez";
  time.timeZone = "America/Los_Angeles";

  mySystem = {
    apps = {
      browsers.enable = true;
      gaming.enable = true;
      office.enable = true;
    };

    desktop = {
      sddm.enable = true;
      plasma.enable = true;
      niri.enable = true;
    };

    users = {
      kenny = {
        enable = true;
        workstation.enable = true;
      };

      karen.enable = true;
      keegan.enable = true;
    };

    hardware.graphics.enable = true;

    profiles = {
      development.enable = true;
      workstation.enable = true;
    };

    system = {
      core.enable = true;
      systemd-boot.enable = true;
      zram.enable = true;
    };

    services = {
      codex.enable = true;
      openssh.enable = true;
      plex.enable = true;
      smartd.enable = true;
      syncthing.enable = true;
      systemdFailureAlerts = {
        enable = true;
        gotify.tokenFile = config.age.secrets."gotify-backups-token".path;
      };
    };
  };

  systemd = {
    services.plex = {
      unitConfig.RequiresMountsFor = [ "/srv/data/media/tv" ];

      bindsTo = [ "srv-data.mount" ];
      after = [ "srv-data.mount" ];
    };

    sleep.settings.Sleep = {
      AllowSuspend = "no";
      AllowHibernation = "no";
      AllowHybridSleep = "no";
      AllowSuspendThenHibernate = "no";
    };
  };

  system.stateVersion = "26.05";
}
