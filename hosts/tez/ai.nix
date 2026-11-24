{ pkgs, pkgs-unstable, ... }:

{
  mySystem.services.local-agent = {
    enable = true;
    repository = "/home/kenny/projects/nixos";
    model = "qwen3.5-codex:9b";

    mcpServers.searxng = {
      url = "http://127.0.0.1:3000/mcp";

      enabled_tools = [
        "searxng_web_search"
        "web_url_read"
      ];

      # Allow autonomous web research without interactive approval.
      tools.searxng_web_search.approval_mode = "approve";
      tools.web_url_read.approval_mode = "approve";
    };
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    host = "127.0.0.1";
    port = 11434;
    openFirewall = false;

    environmentVariables = {
      OLLAMA_NO_CLOUD = "1";
    };
  };

  services.open-webui = {
    enable = true;

    host = "10.0.10.20";
    port = 8080;
    openFirewall = false;

    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
      WEBUI_URL = "https://ai.home.kinghq.net";

      # File editing and commands use the separate codex-local launcher.
      ENABLE_PLUGINS = "False";
      ENABLE_CODE_EXECUTION = "False";
      ENABLE_CODE_INTERPRETER = "False";
    };
  };

  systemd.services = {
    mcp-searxng = {
      description = "SearXNG MCP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment = {
        SEARXNG_URL = "https://search.home.kinghq.net";

        MCP_HTTP_HOST = "127.0.0.1";
        MCP_HTTP_PORT = "3000";

        # Reduce tool definitions and results for local models.
        SEARXNG_LITE_TOOLS = "true";
        SEARXNG_MAX_RESULTS = "5";
        SEARXNG_MAX_RESULT_CHARS = "500";
        URL_READ_MAX_CHARS = "12000";

        # Prevent webpage retrieval from accessing internal services.
        MCP_HTTP_ALLOW_PRIVATE_URLS = "false";
      };

      serviceConfig = {
        ExecStart = "${pkgs-unstable.mcp-searxng}/bin/mcp-searxng";
        Restart = "on-failure";
        RestartSec = "5s";

        DynamicUser = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        NoNewPrivileges = true;
        CapabilityBoundingSet = "";
      };
    };

    open-webui.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

}
