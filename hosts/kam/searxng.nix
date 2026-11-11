{ config, pkgs-unstable, ... }:

{
  age.secrets."searxng-env".file = ../../secrets/searxng-env.age;

  services.searx = {
    enable = true;
    package = pkgs-unstable.searxng;
    environmentFile = config.age.secrets."searxng-env".path;

    settings = {
      general.instance_name = "King HQ Search";

      server = {
        bind_address = "0.0.0.0";
        port = 8888;
        base_url = "https://search.home.kinghq.net/";
        secret_key = "$SEARXNG_SECRET";

        public_instance = false;
        limiter = false;
      };

      search.formats = [
        "html"
        "json"
      ];
    };
  };
}
