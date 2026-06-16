{ pkgs, ... }:
let
  timeZone = "America/Los_Angeles";
  locale = "en_US.UTF-8";
in
{
  imports = [
    ../../users/kenny
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = timeZone;

  # Select internationalisation properties.
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Core system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  programs.zsh.enable = true;

  # Nix system settings
  nix = {
    # Enable Nix Flakes natively
    settings.experimental-features = [ "nix-command" "flakes" ];

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

  };
}
