{ lib, ... }:
{
  plugins.gitsigns = {
    enable = true;

    settings = {
      current_line_blame = false;
      numhl = false;
      linehl = false;
      word_diff = false;

      on_attach = lib.nixvim.mkRaw ''
        function(bufnr)
          local gs = require("gitsigns")

          vim.keymap.set("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end, {
            buffer = bufnr,
            desc = "Next Git change",
          })

          vim.keymap.set("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end, {
            buffer = bufnr,
            desc = "Previous Git change",
          })
        end
      '';
    };
  };
}
