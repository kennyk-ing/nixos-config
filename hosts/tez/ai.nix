{ pkgs, ... }:

{
  mySystem.services.local-agent = {
    enable = true;
    repository = "/home/kenny/projects/nixos";
    model = "qwen3.5-codex:9b";
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

  systemd.services.open-webui.serviceConfig = {
    Restart = "on-failure";
    RestartSec = "10s";
  };
}
