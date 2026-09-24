{ ... }:

{
  services.homepage-dashboard = {
    enable = true;
    openFirewall = false;

    allowedHosts = "home.kinghq.net,localhost:8082,127.0.0.1:8082";

    settings = {
      title = "King HQ";
      target = "_self";
    };

    services = [
      {
        Media = [
          {
            Plex = {
              icon = "plex.png";
              href = "https://plex.home.kinghq.net";
              description = "Watch movies and TV";
            };
          }
          {
            Seerr = {
              href = "https://seerr.home.kinghq.net";
              description = "Request movies and TV";
            };
          }
        ];
      }

      {
        AI = [
          {
            "Open WebUI" = {
              icon = "open-webui.png";
              href = "https://ai.home.kinghq.net";
              description = "Local AI";
            };
          }
        ];
      }
    ];
  };
}
