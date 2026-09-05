{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    imports = [
      ../../../../modules/apps/nixvim/base
      ./workstation
    ];
  };
}
