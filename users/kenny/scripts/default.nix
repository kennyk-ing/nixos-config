{ pkgs, ... }:

let
  rebuild-host = pkgs.writeShellApplication {
    name = "rebuild-host";

    runtimeInputs = with pkgs; [
      git
      nixos-rebuild-ng
    ];

    text = builtins.readFile ./rebuild-host.sh;
  };
in
{
  home.packages = [
    rebuild-host
  ];
}
