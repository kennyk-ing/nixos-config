{
  pkgs,
  lib,
  osConfig,
  ...
}:

let
  cfg = osConfig.mySystem.users.kenny;
  isWorkstation = cfg.workstation.enable;
in
lib.mkIf cfg.enable {
  # Stuff that goes on every system
  programs = {
    eza = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      git = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    ripgrep.enable = true;
    btop.enable = true;
    jq.enable = true;
    bat.enable = true;
  };

  home.packages =
    with pkgs;
    [
      fd
      fastfetch
    ]
    ++ lib.optionals isWorkstation [
      # Workstation only
      wl-clipboard
    ];

  # Workstation only
  programs = {
    yazi = {
      enable = isWorkstation;
      enableBashIntegration = isWorkstation;
      enableZshIntegration = isWorkstation;
    };
  };
}
