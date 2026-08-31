{
  plugins.mini = {
    enable = true;
    mockDevIcons = true;

    modules = {
      icons = { };

      files = {
        mappings = {
          show_help = "?";
        };
        options = {
          use_as_default_explorer = true;
        };
        windows = {
          preview = true;
          width_preview = 60;
        };
      };

      ai = {
        mappings = {
          # Preserve Neovim 0.12's native `an` / `in`
          # Treesitter incremental-selection mappings.
          around_next = "aN";
          inside_next = "iN";

          # Also avoid the newer native `al` / `il` mappings
          # that are arriving in newer Neovim versions.
          around_last = "aL";
          inside_last = "iL";
        };
      };

      pairs = { };

      surround = {
        mappings = {
          # Use the common `gs` prefix instead of overriding normal `s`.
          add = "gsa";
          delete = "gsd";
          find = "gsf";
          find_left = "gsF";
          highlight = "gsh";
          replace = "gsr";

          # Keep MiniSurround's next/last suffixes.
          suffix_last = "l";
          suffix_next = "n";
        };
      };
    };
  };
}
