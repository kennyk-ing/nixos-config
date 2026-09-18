{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./storage.nix
  ];

  networking.hostName = "tez";
  time.timeZone = "America/Los_Angeles";

  networking.firewall.interfaces = {
    enp11s0.allowedTCPPorts = [
      22 # ssh
      32400 # plex
    ];
    tailscale0.allowedTCPPorts = [
      22 # ssh
    ];
  };

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
