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

      home.username = "kenny";
      home.homeDirectory = "/home/kenny";

      programs = {
        home-manager.enable = true;
      };

      # Do not change this value after initial setup
      home.stateVersion = "26.05";
    };

    environment = {
      systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      shellAliases = {
        v = "nvim";
        vi = "nvim";
        vim = "nvim";
        nixsw = "nixos-rebuild switch --flake ~/configs/nixos --sudo";
      };
    };
  };
}
