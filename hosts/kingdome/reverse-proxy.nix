{ ... }:

{
  security.acme.certs."home.kinghq.net" = {
    group = "caddy";
    reloadServices = [ "caddy.service" ];
  };

  services.caddy = {
    enable = true;
    openFirewall = false;

    # NixOS ACME manages certificates; Caddy must not request its own
    # or create an HTTP listener for automatic redirects.
    globalConfig = ''
      auto_https off
    '';

    virtualHosts = {
      "gotify.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 127.0.0.1:8080
        '';
      };

      "tautulli.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 127.0.0.1:8181
        '';
      };
    };
  };

  systemd.services.caddy = {
    requires = [ "acme-home.kinghq.net.service" ];
    after = [ "acme-home.kinghq.net.service" ];
  };
}
