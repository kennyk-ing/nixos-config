{ config, lib, ... }:

let
  cfg = config.mySystem.services.openssh;
in
{
  options.mySystem.services.openssh = {
    enable = lib.mkEnableOption "OpenSSH server";
  };

  config = {
    services.openssh = {
      enable = cfg.enable;

      # Keep host SSH keys available for agenix even when sshd is disabled.
      generateHostKeys = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
