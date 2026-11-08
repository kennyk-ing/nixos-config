{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.mySystem.users.kenny.workstation;
in
{
  imports = [
    ./codex.nix
  ];

  options.mySystem.users.kenny.workstation = {
    enable = lib.mkEnableOption "Kenny's Graphical Workstation Additions";
  };

  config = lib.mkIf cfg.enable {
    users.users.kenny.extraGroups = [ "networkmanager" ];

    mySystem.apps.emacs.enable = true;
    mySystem.users.kenny.terminal.enable = lib.mkDefault true;

    home-manager.users."kenny" = {
      imports = [
        ./apps/browsers.nix
        ./apps/emacs.nix
        ./apps/nixvim
        ./apps/thunderbird.nix
        ./plasma
      ];

      home.packages = with pkgs; [
        anki
        kdePackages.kate
        virt-viewer
      ];

      programs = {
        obsidian = {
          enable = true;
        };

        calibre = {
          enable = true;
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };
      };
    };
  };
}
