{ pkgs, config, lib, ... }:
let
  cfg = config.mySystem.users.kenny.workstation;
in
{
  options.mySystem.users.kenny.workstation = {
    enable = lib.mkEnableOption "Kenny's Graphical Workstation Additions";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users."kenny" = {
      imports = [
        ./apps/thunderbird.nix
      ];

      home.packages = with pkgs; [
        kdePackages.kate
        fira
        nerd-fonts.sauce-code-pro
      ];

      # Make sure home manager can install fonts to the system catalog
      fonts.fontconfig.enable = true;

      home.file.".p10k.zsh".source = ./files/p10k.zsh;

      programs = {
        zsh = {
          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
          ];
          initContent = ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
          '';
        };

        wezterm = {
          enable = true;
          enableBashIntegration = true;
          enableZshIntegration = true;
          extraConfig = builtins.readFile ./files/wezterm.lua;
        };

        obsidian = {
          enable = true;
        };
      };
    };
  };
}

