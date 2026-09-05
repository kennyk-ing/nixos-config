{ config, lib, ... }:

let
  cfg = config.mySystem.apps.nixvim;
in
{
  options.mySystem.apps.nixvim = {
    enable = lib.mkEnableOption "Shared Base Nixvim Configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      imports = [
        ./base
      ];
    };
  };
}
