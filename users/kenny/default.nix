{ pkgs, inputs, config, lib, ... }:
let
  cfg = config.mySystem.users.kenny;
in
{
  options.mySystem.users.kenny = {
    enable = lib.mkEnableOption "Kenny's Base User Profile";
  };

  config = lib.mkIf cfg.enable {
    users.users."kenny" = {
      isNormalUser = true;
      description = "Kenny King";
      extraGroups = [ "networkmanager" "wheel" ];
      initialHashedPassword = "$6$WQgmk1aoS.v2d7NO$n1R./0iPPER4.PCPZPs09JiS3oSTxKYjtn3eeKF1egFNY/NND2w1/cpQcDhTrGip/eOdySSK0ZEIA.E2PDZIq/"; #changeme
      shell = pkgs.zsh;
    };

    home-manager.users."kenny" = {
      imports = [
        ./apps/git.nix
        ./apps/ssh.nix
        ./apps/zsh.nix
      ];

      home.username = "kenny";
      home.homeDirectory = "/home/kenny";

      home.packages = with pkgs; [
        btop
      ];

      programs = {
        home-manager.enable = true;
      };

      # Do not change this value after initial setup
      home.stateVersion = "26.05"; 
    };

    environment = {
      systemPackages = [
        inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.my-nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default
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
