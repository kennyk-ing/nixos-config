{
  imports = [
    ./coding.nix
    ./editor.nix
    ./git.nix
    ./keymaps.nix
    ./mini.nix
    ./snacks.nix
    ./ui.nix
  ];

  opts = {
    # Use the desktop system clipboard.
    clipboard = "unnamedplus";

    # Lualine displays the current mode.
    showmode = false;
  };
}
