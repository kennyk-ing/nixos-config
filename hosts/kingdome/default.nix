{ ... }:

{
  networking = {
    hostName = "kingdome";
    firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  };

  time.timeZone = "America/Los_Angeles";

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  users.users.kenny.extraGroups = [ "libvirtd" ];

  mySystem = {
    users.kenny.enable = true;

    system = {
      core.enable = true;
    };

    services = {
      libvirt.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
    };
  };

  system.stateVersion = "26.05";
}
