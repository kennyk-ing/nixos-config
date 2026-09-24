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
      "home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 127.0.0.1:8082
        '';
      };

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

      "sonarr.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:8989
        '';
      };

      "radarr.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:7878
        '';
      };

      "prowlarr.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:9696
        '';
      };

      "bazarr.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:6767
        '';
      };

      "seerr.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:5055
        '';
      };

      "plex.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          redir / /web 302
          reverse_proxy tez.home.kinghq.net:32400
        '';
      };

      "ai.home.kinghq.net" = {
        listenAddresses = [ "10.0.10.2" ];

        extraConfig = ''
          tls /var/lib/acme/home.kinghq.net/fullchain.pem /var/lib/acme/home.kinghq.net/key.pem
          reverse_proxy 10.0.10.20:8080
        '';
      };
    };
  };

  systemd.services.caddy = {
    requires = [ "acme-home.kinghq.net.service" ];
    after = [ "acme-home.kinghq.net.service" ];
  };
}
