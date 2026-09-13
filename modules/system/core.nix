{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.system.core;
in
{
  options.mySystem.system.core = {
    enable = lib.mkEnableOption "Core System Configurations";
  };

  config = lib.mkIf cfg.enable {
    mySystem.apps.nixvim.enable = true;

    # --- Base System Tools ---
    environment = {
      systemPackages = with pkgs; [
        wget
        git
        ghostty.terminfo
      ];

      shellAliases = {
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
      };
    };

    # --- Localization ---
    i18n.defaultLocale = "en_US.UTF-8";

    # --- Nix & Flakes ---
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        trusted-users = [ "kenny" ];
      };

      gc = {
        automatic = true;
        dates = [ "Tue 03:00" ];
        options = "--delete-older-than 30d";
      };

      optimise = {
        automatic = true;
        dates = [ "Tue 04:00" ];
      };
    };

    # --- Shell ---
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # --- Security & Firewall ---
    networking.firewall.enable = true;
    security.sudo.execWheelOnly = true;

    # --- Hardware ---
    services.fstrim.enable = true;
    hardware.enableRedistributableFirmware = true;

    # --- Host Identity Keys ---
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
