{ pkgs, ... }:

{
  containers.torrent = {
    autoStart = true;
    macvlans = [ "vlan110" ];

    config = {
      networking = {
        enableIPv6 = false;
        useDHCP = false;
        useHostResolvConf = false;

        interfaces.mv-vlan110.ipv4.addresses = [
          {
            address = "10.0.110.10";
            prefixLength = 24;
          }
        ];

        defaultGateway = {
          address = "10.0.110.1";
          interface = "mv-vlan110";
        };

        # Prefer the DNS server from your TorGuard-generated config here.
        # If none was supplied, use a public resolver for the initial test.
        nameservers = [ "1.1.1.1" ];
      };

      environment.systemPackages = with pkgs; [
        curl
        iproute2
      ];

      # Do not change after initial deployment.
      system.stateVersion = "26.05";
    };
  };
}
