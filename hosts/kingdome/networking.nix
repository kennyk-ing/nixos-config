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

    address = [ "10.0.10.2/24" ];
    gateway = [ "10.0.10.1" ];
    dns = [ "10.0.10.1" ];
  };
}
