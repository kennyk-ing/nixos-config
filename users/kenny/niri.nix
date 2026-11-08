{ config, lib, ... }:
{
  config = lib.mkIf (config.mySystem.users.kenny.enable && config.mySystem.desktop.niri.enable) {
    home-manager.users.kenny = {
      # Home Manager loads this through Zsh's .zshenv; niri-session starts
      # the login shell and imports its environment before starting Niri.
      # Hosts can override the existing workstation browser preference.
      home.sessionVariables.BROWSER = lib.mkDefault "zen-beta";
      xdg.configFile =
        (lib.mapAttrs' (
          name: _:
          lib.nameValuePair "niri/${name}" {
            source = ../../modules/desktop/niri/configs + "/${name}";
          }
        ) (builtins.removeAttrs (builtins.readDir ../../modules/desktop/niri/configs) [ "binds.kdl" ]))
        // {
          # Omit workstation application shortcuts when those apps are absent.
          "niri/binds.kdl".text =
            lib.replaceStrings
              (lib.optionals (!config.mySystem.users.kenny.workstation.enable) [
                ''Mod+E repeat=false { spawn "thunderbird"; }''
                ''Mod+N repeat=false { spawn "emacs"; }''
              ])
              (lib.optionals (!config.mySystem.users.kenny.workstation.enable) [
                ""
                ""
              ])
              (builtins.readFile ../../modules/desktop/niri/configs/binds.kdl);
          "noctalia/config.toml".source = ./files/noctalia.toml;
        };
    };
  };
}
