{ config, lib, ... }:

let
  enabled = config.mySystem.users.kenny.enable && config.mySystem.services.codex.enable;
in
{
  config = lib.mkIf enabled {
    mySystem.services.codex = {
      workingDirectory = "/var/lib/codex/workspace/nixos";

      projectDirs = [
        "/var/lib/codex/workspace/nixos"
        "/var/lib/codex/workspace/reference"
        "/var/lib/codex/workspace/work"
      ];

      writableRoots = [
        "/var/lib/codex/workspace/work"
      ];

      readOnlyBinds = [
        "/home/kenny/configs/nixos/.git:/var/lib/codex/workspace/nixos/.git"
        "/home/kenny/AI-Shared/reference:/var/lib/codex/workspace/reference"
        "/home/kenny/org:/var/lib/codex/workspace/org"
      ];

      writableBinds = [
        "/home/kenny/configs/nixos:/var/lib/codex/workspace/nixos"
        "/home/kenny/AI-Shared/work:/var/lib/codex/workspace/work"
      ];
    };

    systemd.tmpfiles.rules = [
      # Codex workspace mount destinations
      "d /var/lib/codex/workspace/nixos 0755 codex codex -"
      "d /var/lib/codex/workspace/reference 0755 codex codex -"
      "d /var/lib/codex/workspace/work 0755 codex codex -"
      "d /var/lib/codex/workspace/org 0755 codex codex -"

      # Kenny's shared directories
      "d /home/kenny/AI-Shared 0700 kenny users -"

      # Reference files: read-only for Codex
      "d /home/kenny/AI-Shared/reference 0750 kenny users -"
      "a+ /home/kenny/AI-Shared/reference - - - - u:codex:r-x,g::---,m::r-x,d:u:codex:r-x,d:g::---,d:m::r-x"

      # Working files: read/write for Kenny and Codex
      "d /home/kenny/AI-Shared/work 0770 kenny users -"
      "a+ /home/kenny/AI-Shared/work - - - - u:codex:rwx,g::---,m::rwx,d:u:codex:rwx,d:u:kenny:rwx,d:g::---,d:m::rwx"

      # Existing Syncthing Org directory: shared access while preserving ownership
      "a+ /home/kenny/org - - - - u:codex:r-x,d:u:codex:r-x,d:u:kenny:rwx"
    ];
  };
}
