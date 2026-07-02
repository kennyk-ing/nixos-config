{ config, pkgs, lib, ... }:

{
  options.mySystem.desktop.niri.enable = lib.mkEnableOption "Niri WM w/ Noctalia Shell";

  config = lib.mkIf config.mySystem.desktop.niri.enable {
    programs.niri.enable = true;
    mySystem.apps.wezterm.enable = true;
    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";       # Forces Chromium/Electron into Wayland
      MOZ_ENABLE_WAYLAND = "1";   # Forces Firefox/Zen into Wayland
    };

    environment.systemPackages = with pkgs; [
      noctalia-shell
      kdePackages.dolphin
      kdePackages.qtsvg # Fixes blank icons in Dolphin outside of KDE
      kdePackages.polkit-kde-agent-1
      hyprlock
      hypridle
      wl-clipboard
      cliphist
      playerctl # For keyboard controls of media players
      wev # get key name of keyboard keys
    ];

    systemd.user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
}
