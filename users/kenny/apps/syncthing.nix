{ osConfig, ... }:

{
  services.syncthing.enable = osConfig.mySystem.services.syncthing.enable;
}
