{
  config,
  inputs,
  lib,
  ...
}:

let
  cfg = config.mySystem.apps.nixvim;
in
{
  options.mySystem.apps.nixvim = {
    enable = lib.mkEnableOption "Nixvim";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.kenny = {
      imports = [
        inputs.nixvim.homeModules.nixvim
      ];

      programs.nixvim = {
        enable = true;
        defaultEditor = true;

        imports = [
          ./config
        ];
      };
    };
  };
}
