{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.system.secure-boot;
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  options.mySystem.system.secure-boot = {
    enable = lib.mkEnableOption "UEFI Secure Boot with Lanzaboote";

    measured-boot.enable = lib.mkEnableOption "TPM2 measured boot with Lanzaboote";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = [
          {
            # Lanzaboote replaces our normal systemd-boot setup.
            assertion = !config.mySystem.system.systemd-boot.enable;
            message = ''
              mySystem.system.secure-boot and mySystem.system.systemd-boot
              are mutually exclusive.
            '';
          }
        ];

        # Useful for checking signatures and managing Secure Boot keys.
        environment.systemPackages = [
          pkgs.sbctl
        ];

        boot = {
          loader = {
            # Required by Lanzaboote. It installs/manages systemd-boot itself.
            systemd-boot.enable = lib.mkForce false;

            efi.canTouchEfiVariables = true;
          };

          lanzaboote = {
            enable = true;

            # Created by sbctl. Do not delete or regenerate casually.
            pkiBundle = "/var/lib/sbctl";

            # Keep this at 8. systemd-pcrlock currently cannot handle more
            # than 8 variants when measured boot is enabled.
            configurationLimit = 8;

            # Do not allow editing kernel parameters from the boot menu.
            settings.editor = false;
          };
        };
      }

      (lib.mkIf cfg.measured-boot.enable {
        assertions = [
          {
            # Measured boot needs the systemd initrd.
            assertion = config.boot.initrd.systemd.enable;
            message = "Lanzaboote measured boot requires the systemd initrd.";
          }
        ];

        boot.lanzaboote.measuredBoot = {
          enable = true;

          # Recommended starting set. Avoid adding 1/2/3 unless we have a
          # reason; they can be less reliable on some hardware.
          pcrs = [
            0
            4
            7
          ];
        };
      })
    ]
  );
}
