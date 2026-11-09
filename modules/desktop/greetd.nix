{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.mySystem.desktop.greetd.enable = lib.mkEnableOption "greetd login with tuigreet";

  config = lib.mkIf config.mySystem.desktop.greetd.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;

      settings.default_session = {
        command = lib.concatStringsSep " " [
          "${lib.getExe pkgs.tuigreet}"
          "--time"
          "--cmd ${config.programs.niri.package}/bin/niri-session"
        ];

        user = "greeter";
      };
    };

    security.pam.services.greetd.kwallet = {
      enable = true;
      forceRun = true;
    };
  };
}
