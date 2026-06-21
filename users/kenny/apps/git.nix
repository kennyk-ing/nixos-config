{
  programs = {
    git = {
      enable = true;
      settings = {
        user = {
          name = "Kenny King";
          email = "16931002+kennyk-ing@users.noreply.github.com";
        };
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
    lazygit = {
      enable = true;
    };
  };
  home.shellAliases = {
    lg = "lazygit";
  };
}
