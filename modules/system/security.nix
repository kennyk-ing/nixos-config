{ ... }:

{
  networking.firewall.enable = true;
  # networking.firewall.allowedTCPPorts = [ 80 443 ];

  security.sudo.execWheelOnly = true;
}
