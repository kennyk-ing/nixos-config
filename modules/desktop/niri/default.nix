{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.mySystem.desktop.niri.enable = lib.mkEnableOption "Niri WM w/ Noctalia Shell";

  config = lib.mkIf config.mySystem.desktop.niri.enable {
    programs.niri.enable = true;
    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Forces Chromium/Electron into Wayland
      MOZ_ENABLE_WAYLAND = "1"; # Forces Firefox/Zen into Wayland
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
      xwayland-satellite
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

    # Use KWallet as the credential backend in Niri.
    services.gnome.gnome-keyring.enable = false;

    security.pam.services.login.kwallet.enable = true;

    xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";

    # Finish KWallet PAM initialization after Niri starts.
    systemd.user.services.niri-kwallet-init = {
      description = "Initialize KWallet for Niri";

      wantedBy = [ "niri.service" ];
      after = [ "niri.service" ];
      before = [ "xdg-desktop-autostart.target" ];
      partOf = [ "niri.service" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init";
        Environment = "QT_QPA_PLATFORM=wayland";
      };
    };

    home-manager.users.kenny = {
      xdg.configFile."niri" = {
        source = ./configs;
        recursive = true;
      };
    };
  };
}
