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
    # Preserve the login session PATH instead of NixOS's stripped service PATH.
    systemd.user.services.niri.enableDefaultPath = false;
    security.polkit.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Forces Chromium/Electron into Wayland
      MOZ_ENABLE_WAYLAND = "1"; # Forces Firefox/Zen into Wayland
    };

    environment.systemPackages = with pkgs; [
      noctalia # Native v5 shell with integrated clipboard history.
      brightnessctl # Used directly by niri's brightness shortcuts.
      kdePackages.dolphin
      kdePackages.qtsvg # Fixes blank icons in Dolphin outside of KDE
      kdePackages.polkit-kde-agent-1
      wl-clipboard
      playerctl # For keyboard controls of media players
      wev # get key name of keyboard keys
      xwayland-satellite
    ];

    # Use KWallet as the credential backend in Niri.
    services.gnome.gnome-keyring.enable = false;

    security.pam.services.login.kwallet.enable = true;

    # Niri also needs the backend when Plasma is not installed.
    xdg.portal.extraPortals = [ pkgs.kdePackages.kwallet ];

    xdg.portal.config.niri."org.freedesktop.impl.portal.Secret" = lib.mkForce "kwallet";

    systemd.user.services = {
      polkit-kde-authentication-agent-1 = {
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

      # Finish KWallet PAM initialization after Niri starts.
      niri-kwallet-init = {
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

      niri-bitwarden-float = {
        description = "Float Bitwarden extension windows after their title is set";

        wantedBy = [ "niri.service" ];
        after = [ "niri.service" ];
        partOf = [ "niri.service" ];

        unitConfig = {
          Requisite = "niri.service";
          ConditionEnvironment = "NIRI_SOCKET";
        };

        serviceConfig = {
          ExecStart = "${pkgs.python3}/bin/python3 -u ${./open-float.py}";
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };
  };
}
