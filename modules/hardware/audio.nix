{ lib, config, ... }:
let
  cfg = config.mySystem.hardware.audio;
in
{
  options.mySystem.hardware.audio = {
    enable = lib.mkEnableOption "Pipewire Audio";
  };

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}

