{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mySystem.desktop.greetd.enable = lib.mkEnableOption "greetd login with session selection";

  config = lib.mkIf config.mySystem.desktop.greetd.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;
      settings.default_session = {
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember-user-session"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
        ];
        user = "greeter";
      };
    };

    security.pam.services.greetd.kwallet = {
      enable = true;
      # The greeter authenticates on a TTY before the graphical session starts.
      forceRun = true;
    };
  };
}
