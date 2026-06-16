{ lib, config, pkgs, ... }:

let
  cfg = config.mySystem.system.core;
  timeZone = "America/Los_Angeles";
  locale = "en_US.UTF-8";
in {
  options.mySystem.system.core = {
    enable = lib.mkEnableOption "Core System Configurations";
  };

  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
    ];

    time.timeZone = timeZone;

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

    nixpkgs.config.allowUnfree = true;

    programs.zsh.enable = true;

    nix = {
      settings.experimental-features = [ "nix-command" "flakes" ];
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    networking.firewall.enable = true;
    security.sudo.execWheelOnly = true;
  };
}
