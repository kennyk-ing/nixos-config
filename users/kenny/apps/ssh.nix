{ ... }:
{
  services.ssh-agent.enable = true;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings ={
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
    };
  };
}
