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

        obsidian = {
          enable = true;
        };
      };

      xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = {
            # Word docs
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "onlyoffice-desktopeditors.desktop"; # .docx
            "application/msword" = "onlyoffice-desktopeditors.desktop"; # .doc

            # Excel docs
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" = "onlyoffice-desktopeditors.desktop"; # .xlsx
            "application/vnd.ms-excel" = "onlyoffice-desktopeditors.desktop"; # .xls

            # PowerPoint docs
            "application/vnd.openxmlformats-officedocument.presentationml.presentation" = "onlyoffice-desktopeditors.desktop"; # .pptx
            "application/vnd.ms-powerpoint" = "onlyoffice-desktopeditors.desktop"; # .ppt

            # OpenDocument (LibreOffice) Formats
            "application/vnd.oasis.opendocument.text" = "onlyoffice-desktopeditors.desktop"; # .odt
          };
        };
        desktopEntries."onlyoffice-desktopeditors" = {
          name = "ONLYOFFICE Desktop Editors";
          genericName = "Office Suite";
          # The magic line: explicitly force the X11 display variable on execution
          exec = "env DISPLAY=:0 onlyoffice-desktopeditors %U";
          terminal = false;
          icon = "onlyoffice-desktopeditors";
          type = "Application";
          categories = [ "Office" "WordProcessor" "Spreadsheet" "Presentation" ];
        };
      };
    };
  };
}

