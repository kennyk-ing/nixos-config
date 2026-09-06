{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.mySystem.system.core;
  locale = "en_US.UTF-8";
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
      ];

      shellAliases = {
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
      };
    };

    # --- Localization ---
    i18n.defaultLocale = locale;
    i18n.extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
      LC_TIME = locale;
    };

    # --- Nix & Flakes ---
    nixpkgs.config.allowUnfree = true;
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # --- Shell ---
    programs.zsh.enable = true;
    users.defaultUserShell = pkgs.zsh;

    # --- Security & Firewall ---
    networking.firewall.enable = true;
    security.sudo.execWheelOnly = true;

    # --- Networking ---
    networking.networkmanager.enable = true;

    # --- Hardware ---
    services.fstrim.enable = true;
    hardware.enableRedistributableFirmware = true;
  };
}
