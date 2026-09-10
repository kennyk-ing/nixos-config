{ ... }:

{
  networking = {
    firewall.interfaces = {
      enp0s31f6.allowedTCPPorts = [ 22 ];
      tailscale0.allowedTCPPorts = [ 22 ];
    };
  };

  systemd.network.networks."10-enp0s31f6" = {
    matchConfig.Name = "enp0s31f6";

    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = true;
    };
  };
}
