{
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.kenny;
  keys = import ../../keys.nix;
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
      uid = 1000;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];

      hashedPasswordFile = config.age.secrets."kenny-password".path;
      openssh.authorizedKeys.keys = builtins.attrValues keys.users.kenny;
    };

    home-manager.users."kenny" = {
      imports = [
        ./apps/cli.nix
        ./apps/git.nix
        ./apps/ssh.nix
        ./apps/syncthing.nix
        ./apps/tmux.nix
        ./apps/zsh.nix
      ];

      home = {
        # Do not change this value after initial setup
        stateVersion = "26.05";
      };
    };
  };
}
