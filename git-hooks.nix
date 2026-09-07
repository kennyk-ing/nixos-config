{
  nixfmt = {
    enable = true;
    stages = [ "pre-commit" ];
  };

  statix = {
    enable = true;
    stages = [ "pre-commit" ];
  };

  deadnix = {
    enable = true;
    stages = [ "pre-commit" ];
  };

  flake-check = {
    enable = true;
    name = "nix flake check";
    entry = "nix flake check";
    pass_filenames = false;
    always_run = true;
    stages = [ "pre-push" ];
  };
}
