{
  imports = [
    ./coding.nix
    ./editor.nix
  ];

  opts = {
    # Use the desktop system clipboard.
    clipboard = "unnamedplus";
  };
}
