{ lib, config, pkgs, ... }:
let
  cfg = config.mySystem.apps.gaming;
in {
  options.mySystem.apps.gaming = {
    enable = lib.mkEnableOption "Gaming platform support (Steam, Lutris, etc.)";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    # Essential for Xbox/PS controllers
    hardware.steam-hardware.enable = true;

    # Gamemode automatically optimizes system performance when games run
    programs.gamemode.enable = true;

    # 3. Additional Game Launchers
    environment.systemPackages = with pkgs; [
      lutris                  # Great for Wine/Epic/GOG games
      heroic                  # Open source Epic/GOG/Amazon launcher
      protonup-qt             # GUI to easily install custom Proton-GE versions
    ];

    mySystem.hardware.graphics.enable = true;
  };
}
