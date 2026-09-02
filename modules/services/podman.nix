{ config, lib, ... }:

let
  cfg = config.mySystem.services.podman;
in
{
  options.mySystem.services.podman = {
    enable = lib.mkEnableOption "Podman container runtime";
  };

  config = lib.mkIf cfg.enable {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      # Do NOT expose the system/rootful Podman socket as Docker.
      dockerSocket.enable = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
