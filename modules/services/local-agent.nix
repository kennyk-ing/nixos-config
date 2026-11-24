{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  cfg = config.mySystem.services.local-agent;
  agentHome = "/var/lib/local-agent";
  workspace = "${agentHome}/workspace/nixos";
  agentConfig = (pkgs.formats.toml { }).generate "local-agent-config.toml" {
    inherit (cfg) model;
    model_context_window = 16384;
    model_provider = "ollama";
    oss_provider = "ollama";
    approvals_reviewer = "user";
    approval_policy = "on-request";
    cli_auth_credentials_store = "file";
    check_for_update_on_startup = false;
    # NixOS login initialization replaces PATH with profiles hidden by isolation.
    allow_login_shell = false;
    features.shell_snapshot = false;
    shell_environment_policy.set = {
      PATH = agentPath;
      # NixOS bashrc also sources /etc/profile in non-login shells unless marked.
      __ETC_PROFILE_SOURCED = "1";
      __ETC_PROFILE_DONE = "1";
    };
    tui.vim_mode_default = true;
    sandbox_mode = "workspace-write";
    sandbox_workspace_write.network_access = false;
    projects.${workspace}.trust_level = "untrusted";
    web_search = "disabled";
    mcp_servers = cfg.mcpServers;
  };
  emptyRules = pkgs.runCommand "local-agent-empty-rules" { } ''
    mkdir -p "$out"
  '';
  agentPath = lib.makeBinPath [
    pkgs.bashInteractive
    pkgs.bubblewrap
    pkgs.coreutils
    pkgs.findutils
    pkgs.git
    pkgs.nix
    pkgs.nixfmt
    pkgs.ripgrep
    pkgs.util-linux
  ];
  launcher = pkgs.writeShellScriptBin "codex-local" ''
    exec ${pkgs.systemd}/bin/systemd-run \
      --pty --wait --collect \
      -p User=local-agent \
      -p Group=local-agent \
      -p Environment=HOME=${agentHome} \
      -p Environment=CODEX_HOME=${agentHome}/.codex \
      -p Environment=OLLAMA_HOST=http://127.0.0.1:11434 \
      -p Environment=__ETC_PROFILE_SOURCED=1 \
      -p Environment=__ETC_PROFILE_DONE=1 \
      -p Environment=GIT_CONFIG_COUNT=1 \
      -p Environment=GIT_CONFIG_KEY_0=safe.directory \
      -p Environment=GIT_CONFIG_VALUE_0=${workspace} \
      -p ${lib.escapeShellArg "Environment=PATH=${agentPath}"} \
      -p ProtectHome=tmpfs \
      -p ProtectSystem=strict \
      -p TemporaryFileSystem=/var:ro \
      -p TemporaryFileSystem=/run:ro \
      -p PrivateTmp=yes \
      -p PrivateDevices=yes \
      -p NoNewPrivileges=yes \
      -p CapabilityBoundingSet= \
      -p ProtectKernelTunables=no \
      -p ProtectControlGroups=yes \
      -p ProtectProc=invisible \
      -p IPAddressDeny=any \
      -p IPAddressAllow=127.0.0.1/32 \
      -p InaccessiblePaths=/nix/var/nix/daemon-socket \
      -p BindPaths=${agentHome} \
      -p ${lib.escapeShellArg "BindPaths=${cfg.repository}:${workspace}"} \
      -p ${lib.escapeShellArg "BindReadOnlyPaths=${cfg.repository}/.git:${workspace}/.git"} \
      -p ${lib.escapeShellArg "BindReadOnlyPaths=${agentConfig}:${agentHome}/.codex/config.toml"} \
      -p ${lib.escapeShellArg "BindReadOnlyPaths=${emptyRules}:${agentHome}/.codex/rules"} \
      -p WorkingDirectory=${workspace} \
      -p KillMode=control-group \
      -p TasksMax=256 \
      -p MemoryMax=4G \
    ${pkgs-unstable.codex}/bin/codex \
      --oss \
      --local-provider ollama \
      --model ${lib.escapeShellArg cfg.model} \
      --disable multi_agent \
      --disable multi_agent_v2 \
      --disable goals \
      "$@"
  '';
in
{
  options.mySystem.services.local-agent = {
    enable = lib.mkEnableOption "isolated Codex CLI with local Ollama inference";
    model = lib.mkOption {
      type = lib.types.str;
      description = "Default model already installed locally in Ollama.";
    };
    repository = lib.mkOption {
      type = lib.types.str;
      description = "Ordinary Git checkout shared with the local agent; .git must be a directory.";
    };
    mcpServers = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "MCP server configurations for the local Codex agent.";
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.local-agent = { };
    users.users.local-agent = {
      isSystemUser = true;
      group = "local-agent";
      home = agentHome;
      createHome = true;
      homeMode = "0700";
      hashedPassword = "!";
    };
    services.openssh.settings.DenyUsers = [ "local-agent" ];
    environment.systemPackages = [ launcher ];

    systemd = {
      tmpfiles.rules = [
        "d ${agentHome} 0700 local-agent local-agent -"
        "d ${agentHome}/workspace 0700 local-agent local-agent -"
        "d ${workspace} 0700 local-agent local-agent -"
        "d ${agentHome}/.codex 0700 local-agent local-agent -"
        "d ${agentHome}/.codex/rules 0700 local-agent local-agent -"
        "f ${agentHome}/.codex/config.toml 0600 local-agent local-agent -"
      ];
      # Grant the agent access to repository working files without changing
      # their ownership. Exclude .git and do not follow symbolic links.
      #
      # These ACLs persist if the module is disabled or removed.
      # Disabling the service does not revoke previously granted access.
      services.local-agent-workspace = {
        description = "Grant local agent access to the selected working files";
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          test -d ${lib.escapeShellArg "${cfg.repository}/.git"}
          test ! -L ${lib.escapeShellArg "${cfg.repository}/.git"}
          ${pkgs.findutils}/bin/find ${lib.escapeShellArg cfg.repository} \
            -name .git -prune -o \
            -type d -exec ${pkgs.acl}/bin/setfacl -m u:local-agent:rwx,d:u:local-agent:rwx {} + -o \
            -type f -exec ${pkgs.acl}/bin/setfacl -m u:local-agent:rw {} +
        '';
      };
    };
  };
}
