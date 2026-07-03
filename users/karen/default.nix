{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.mySystem.users.karen;
in
{
  options.mySystem.users.karen = {
    enable = lib.mkEnableOption "Karen's Base User Profile";
  };

  config = lib.mkIf cfg.enable {
    users.users."karen" = {
      isNormalUser = true;
      description = "Karen King";
      extraGroups = [ "networkmanager" ];
      initialHashedPassword = "$6$WQgmk1aoS.v2d7NO$n1R./0iPPER4.PCPZPs09JiS3oSTxKYjtn3eeKF1egFNY/NND2w1/cpQcDhTrGip/eOdySSK0ZEIA.E2PDZIq/"; #changeme
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
