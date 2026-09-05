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
      home = {
        username = "karen";
        homeDirectory = "/home/karen";

        # Do not change this value after initial setup
        stateVersion = "26.05";
      };

      programs = {
        home-manager.enable = true;
        thunderbird.enable = true;
      };
    };

    environment = {
      systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
