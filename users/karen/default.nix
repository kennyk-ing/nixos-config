{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.karen;
in
{
  options.mySystem.users.karen = {
    enable = lib.mkEnableOption "Karen's Base User Profile";
  };

  config = lib.mkIf cfg.enable {
    age.secrets."karen-password".file = ../../secrets/karen-password.age;

    users.users."karen" = {
      isNormalUser = true;
      description = "Karen King";
      extraGroups = [ "networkmanager" ];
      hashedPasswordFile = config.age.secrets."karen-password".path;
      uid = 1001;
    };

    home-manager.users."karen" = {
      home.username = "karen";
      home.homeDirectory = "/home/karen";

      home.packages = with pkgs; [
      ];

      programs = {
        home-manager.enable = true;
        thunderbird.enable = true;
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
      };
    };
  };
}
