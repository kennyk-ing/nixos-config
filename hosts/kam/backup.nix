{ ... }:

{
  users.groups.restic-kingdome = { };

  users.users.restic-kingdome = {
    isSystemUser = true;
    group = "restic-kingdome";
    home = "/";
    createHome = false;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEyd0UuW7sYjtOqUmzQpxgIJx7ZeEEwkJ9lHz+60EYW4 restic-kingdome-to-kam"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/backups 0755 root root - -"
    "d /srv/backups/kingdome 0700 restic-kingdome restic-kingdome - -"
  ];

  services.openssh.extraConfig = ''
    Match User restic-kingdome
      ChrootDirectory /srv/backups
      ForceCommand internal-sftp -d /kingdome
      DisableForwarding yes
      PermitTTY no

    Match all
  '';
}
