{ config, ... }:
{
  imports = [
    ./backup.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./homepage.nix
    ./networking.nix
    ./reverse-proxy.nix
    ./vfio.nix
  ];

  networking.hostName = "kingdome";
  time.timeZone = "America/Los_Angeles";

  users.users.kenny.extraGroups = [ "libvirtd" ];

  age.secrets = {
    "gotify-env".file = ../../secrets/gotify-env.age;
    "cloudflare-acme".file = ../../secrets/cloudflare-acme.age;
    "gotify-backups-token".file = ../../secrets/gotify-backups-token.age;
  };

  fileSystems."/srv/backups" = {
    device = "/dev/disk/by-uuid/7f0cf1eb-f891-40c0-8e24-c239613c65b7";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
    ];
  };

  mySystem = {
    users.kenny.enable = true;

    profiles.server.enable = true;

    services = {
      libvirt.enable = true;
      openssh.enable = true;
      smartd.enable = true;

      systemdFailureAlerts = {
        enable = true;
        gotify.tokenFile = config.age.secrets."gotify-backups-token".path;
      };
    };

    system = {
      core.enable = true;
      systemd-boot.enable = true;
    };
  };

  services = {
    gotify = {
      enable = true;

      environment = {
        GOTIFY_SERVER_LISTENADDR = "127.0.0.1";
        GOTIFY_SERVER_PORT = 8080;
      };

      environmentFiles = [
        config.age.secrets."gotify-env".path
      ];
    };

    tautulli.enable = true;
  };

  systemd.services.tautulli.environment = {
    TAUTULLI_HTTP_HOST = "127.0.0.1";
  };

  environment.etc."kingdome-recovery/hodor.xml".source = ./hodor.xml;
  virtualisation.libvirtd.onShutdown = "shutdown";

  security.acme = {
    acceptTerms = true;

    defaults.email = "kenny@kinghq.net";

    certs."home.kinghq.net" = {
      extraDomainNames = [ "*.home.kinghq.net" ];

      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";

      environmentFile = config.age.secrets."cloudflare-acme".path;
    };
  };

  system.stateVersion = "26.05";
}
