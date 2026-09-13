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

        # SSH multiplexing
        ControlMaster = "auto";
        ControlPersist = "10m";
        ControlPath = "~/.ssh/control-%C";

        # Detect dead connections
        ServerAliveInterval = 30;
        ServerAliveCountMax = 3;
      };
      "github.com" = {
        host = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
        RequestTTY = "no";
      };

      # We add this explicitly instead of using DNS so we can access
      # kingdome even if DNS or hodor are down
      kingdome = {
        HostName = "10.0.10.2";
        User = "kenny";
      };
    };
  };
}
