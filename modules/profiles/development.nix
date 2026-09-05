{ config, lib, ... }:

let
  cfg = config.mySystem.profiles.development;
in
{
  options.mySystem.profiles.development = {
    enable = lib.mkEnableOption "development workstation features";
  };

  config = lib.mkIf cfg.enable {
    # Compatibility for project-local binaries from npm, etc.
    programs.nix-ld.enable = true;

    # Development container runtime.
    mySystem.services.podman.enable = true;
  };
}
