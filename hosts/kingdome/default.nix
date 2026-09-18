{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./networking.nix
    ./vfio.nix
  ];

  networking.hostName = "kingdome";
  time.timeZone = "America/Los_Angeles";

  users.users.kenny.extraGroups = [ "libvirtd" ];

  age.secrets."gotify-env".file = ../../secrets/gotify-env.age;

  mySystem = {
    users.kenny.enable = true;

    profiles.server.enable = true;

    services = {
      libvirt.enable = true;
      openssh.enable = true;
      smartd.enable = true;
      tailscale.enable = true;
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

  system.stateVersion = "26.05";
}
