{ ... }:

{
  imports = [
    ./ai.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./networking.nix
    ./servarr.nix
    ./storage.nix
    ./torrent.nix
  ];

  networking.hostName = "tez";
  time.timeZone = "America/Los_Angeles";

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };

  mySystem = {
    apps = {
      emacs.enable = true;
      browsers.enable = true;
      gaming.enable = true;
      office.enable = true;
    };

    desktop = {
      sddm.enable = true;
      plasma.enable = true;
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
      openssh.enable = true;
      plex.enable = true;
      syncthing.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
    };
  };

  systemd.services.plex = {
    unitConfig.RequiresMountsFor = [ "/srv/data/media/tv" ];

    bindsTo = [ "srv-data.mount" ];
    after = [ "srv-data.mount" ];
  };

  system.stateVersion = "26.05";
}
