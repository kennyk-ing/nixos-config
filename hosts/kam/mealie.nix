{
  pkgs-unstable,
  ...
}:

{
  services.mealie = {
    enable = true;
    package = pkgs-unstable.mealie;

    listenAddress = "10.0.100.10";
    port = 9000;

    settings = {
      BASE_URL = "https://recipes.home.kinghq.net";
      ALLOW_SIGNUP = "false";

      DEFAULT_GROUP = "Home";
      DEFAULT_HOUSEHOLD = "Family";

      # Trust forwarded headers only from Kingdome.
      HOST_IP = "10.0.10.2";
    };
  };

  systemd.services.mealie.unitConfig.OnFailure = [
    "systemd-failure-alert@%N.service"
  ];
}
