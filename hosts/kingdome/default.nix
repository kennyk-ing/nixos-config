{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./vfio.nix
  ];

  networking = {
    hostName = "kingdome";

    firewall.interfaces = {
      # Onboard - bootstrap management from TRUSTED for now.
      # This will later become the dedicated MGMT connection.
      enp0s31f6.allowedTCPPorts = [ 22 ];

      tailscale0.allowedTCPPorts = [ 22 ];
    };
  };

  time.timeZone = "America/Los_Angeles";

  users.users.kenny.extraGroups = [ "libvirtd" ];

  mySystem = {
    users.kenny.enable = true;

    system = {
      core.enable = true;
      systemd-boot.enable = true;
    };

    services = {
      libvirt.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
