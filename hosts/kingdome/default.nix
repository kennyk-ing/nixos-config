{ ... }:

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

  mySystem = {
    users.kenny.enable = true;

    profiles.server.enable = true;

    services = {
      libvirt.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };

    system = {
      core.enable = true;
      systemd-boot.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
