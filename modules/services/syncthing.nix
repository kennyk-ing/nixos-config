{ lib, ... }:
{
  options.mySystem.services.syncthing = {
    enable = lib.mkEnableOption "Syncthing";
  };
}
