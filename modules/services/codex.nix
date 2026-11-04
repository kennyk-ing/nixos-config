{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  cfg = config.mySystem.services.codex;

  # Agent configuration, stored read-only in the Nix store.
  codexConfig = (pkgs.formats.toml { }).generate "codex-config.toml" {
    approval_policy = "on-request";
    approvals_reviewer = "user";
    cli_auth_credentials_store = "file";
    check_for_update_on_startup = false;
    tui.vim_mode_default = true;

    sandbox_mode = "workspace-write";

    sandbox_workspace_write = {
      network_access = false;
      writable_roots = cfg.writableRoots;
    };

    # Trust configured projects while retaining sandbox restrictions.
    projects = lib.genAttrs cfg.projectDirs (_: {
      trust_level = "trusted";
    });
  };

  # Prevent persistent shell-command allow rules.
  emptyRules = pkgs.runCommand "codex-empty-rules" { } ''
    mkdir -p "$out"
  '';

  # Generate systemd bind-mount arguments.
  readOnlyArgs = lib.concatMapStringsSep "\n" (
    bind: "-p ${lib.escapeShellArg "BindReadOnlyPaths=${bind}"}"
  ) cfg.readOnlyBinds;

  writableArgs = lib.concatMapStringsSep "\n" (
    bind: "-p ${lib.escapeShellArg "BindPaths=${bind}"}"
  ) cfg.writableBinds;

  codexPath = lib.makeBinPath [
    pkgs.bashInteractive
    pkgs.bubblewrap
    pkgs.coreutils
    pkgs.findutils
    pkgs.git
    pkgs.nix
    pkgs.ripgrep
    pkgs.util-linux
  ];

  launcher = pkgs.writeShellScriptBin "codex-safe" ''
    args=(
      --pty
      --wait
      --collect

      -p User=codex
      -p Group=codex

      -p Environment=HOME=/var/lib/codex
      -p Environment=CODEX_HOME=/var/lib/codex/.codex
      -p ${lib.escapeShellArg "Environment=PATH=${codexPath}"}

      -p ProtectHome=tmpfs
      -p ProtectSystem=strict
      -p PrivateTmp=yes
      -p PrivateDevices=yes
      -p NoNewPrivileges=yes
      -p CapabilityBoundingSet=
      -p ProtectKernelTunables=no
      -p ProtectControlGroups=yes
      -p ProtectProc=invisible

      -p ReadWritePaths=/var/lib/codex

      -p ${lib.escapeShellArg "BindReadOnlyPaths=${codexConfig}:/var/lib/codex/.codex/config.toml"}
      -p ${lib.escapeShellArg "BindReadOnlyPaths=${emptyRules}:/var/lib/codex/.codex/rules"}

      -p ${lib.escapeShellArg "WorkingDirectory=${cfg.workingDirectory}"}

      ${readOnlyArgs}
      ${writableArgs}
    )

    exec ${pkgs.systemd}/bin/systemd-run \
      "''${args[@]}" \
      ${pkgs-unstable.codex}/bin/codex "$@"
  '';
in
{
  options.mySystem.services.codex = {
    enable = lib.mkEnableOption "isolated Codex agent";

    workingDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/codex/workspace";
      description = "Initial Codex working directory.";
    };

    projectDirs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Directories treated as trusted projects.";
    };

    readOnlyBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Read-only source:destination bind mounts.";
    };

    writableBinds = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Writable source:destination bind mounts.";
    };

    writableRoots = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional writable directories inside the Codex sandbox.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.codex = { };

    users.users.codex = {
      isSystemUser = true;
      group = "codex";

      home = "/var/lib/codex";
      createHome = true;
      homeMode = "0700";

      shell = pkgs.bashInteractive;
      hashedPassword = "!";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/codex/workspace 0700 codex codex -"
      "d /var/lib/codex/.codex 0700 codex codex -"
      "d /var/lib/codex/.codex/rules 0700 codex codex -"
      "f /var/lib/codex/.codex/config.toml 0600 codex codex -"
    ];

    services.openssh.settings.DenyUsers = [ "codex" ];

    # Only expose the protected launcher, not pkgs.codex.
    environment.systemPackages = [ launcher ];
  };
}
