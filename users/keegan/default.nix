{
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.keegan;
in
{
  options.mySystem.users.keegan = {
    enable = lib.mkEnableOption "Keegan's Base User Profile";
  };

  config = lib.mkIf cfg.enable {
    age.secrets."keegan-password".file = ../../secrets/keegan-password.age;

    users.users."keegan" = {
      isNormalUser = true;
      description = "Keegan King";
      extraGroups = [ "networkmanager" ];
      hashedPasswordFile = config.age.secrets."keegan-password".path;
      uid = 1002;
    };

    home-manager.users."keegan" = {
      home = {
        # Do not change this value after initial setup
        stateVersion = "26.05";
      };

      programs = {
        thunderbird.enable = true;
      };
    };
  };
}
