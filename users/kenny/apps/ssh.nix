{ ... }:
{
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;

    # Opt out of Home Manager's legacy Host * defaults; define SSH defaults
    # explicitly in `settings` instead.
    enableDefaultConfig = false;

    settings = {
      "*" = {
        AddKeysToAgent = "yes";
      };
      "github.com" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        RequestTTY = "no";
      };
      "kirby" = {
        ControlMaster = "auto";
        ControlPersist = "10m";
        ControlPath = "~/.ssh/control-%C";

        ServerAliveInterval = 30;
        ServerAliveCountMax = 3;
      };
    };
  };
}
