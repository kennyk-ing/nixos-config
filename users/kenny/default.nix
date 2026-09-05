{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.kenny;
in
{
  options.mySystem.users.kenny = {
    enable = lib.mkEnableOption "Kenny's Base User Profile";
  };

  config = lib.mkIf cfg.enable {
    age.secrets."kenny-password".file = ../../secrets/kenny-password.age;

    users.users."kenny" = {
      isNormalUser = true;
      description = "Kenny King";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      hashedPasswordFile = config.age.secrets."kenny-password".path;
      uid = 1000;
      shell = pkgs.zsh;
      linger = true; # run systemd user services at boot
    };

    home-manager.users."kenny" = {
      imports = [
        ./apps/git.nix
        ./apps/ssh.nix
        ./apps/zsh.nix
        ./apps/cli.nix
      ];

      home = {
        username = "kenny";
        homeDirectory = "/home/kenny";

        # Do not change this value after initial setup
        stateVersion = "26.05";
      };

      programs = {
        home-manager.enable = true;
      };
    };

    environment = {
      systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
