{ pkgs, lib, osConfig, ... }:

let
  cfg = osConfig.mySystem.users.kenny;
  isWorkstation = cfg.workstation.enable;
in
lib.mkIf cfg.enable {
  # Stuff that goes on every system
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    git = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.ripgrep.enable = true;
  programs.btop.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;

  home.packages = with pkgs; [
    fd
    fastfetch
  ] ++ lib.optionals isWorkstation [
    # Workstation only
    wl-clipboard
  ];

# Workstation only
  programs.yazi = {
    enable = isWorkstation;
    enableBashIntegration = isWorkstation;
    enableZshIntegration = isWorkstation;
  };
}
