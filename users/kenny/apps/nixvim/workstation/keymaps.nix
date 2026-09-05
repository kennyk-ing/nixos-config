{ lib, ... }:

{
  keymaps = [
    ## [S]earch

    # Search text in the project
    {
      mode = "n";
      key = "<leader>sg";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.grep()
        end
      '';
      options.desc = "[S]earch [G]rep";
    }

    # Search lines in the current buffer
    {
      mode = "n";
      key = "<leader>sb";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.lines()
        end
      '';
      options.desc = "[S]earch [B]uffer";
    }

    # Search help
    {
      mode = "n";
      key = "<leader>sh";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.help()
        end
      '';
      options.desc = "[S]earch [H]elp";
    }

    # Search keymaps
    {
      mode = "n";
      key = "<leader>sk";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.keymaps()
        end
      '';
      options.desc = "[S]earch [K]eymaps";
    }

    # Search the word under the cursor or current visual selection
    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>sw";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.grep_word()
        end
      '';
      options.desc = "[S]earch [W]ord";
    }

    ## [F]ind/File

    # File Explorer
    {
      mode = "n";
      key = "<leader>fe";
      action = lib.nixvim.mkRaw ''
        function()
          local MiniFiles = require("mini.files")

          if MiniFiles.close() == nil then
            local path = vim.api.nvim_buf_get_name(0)

            if path == "" then
              path = nil
            end

            MiniFiles.open(path)
          end
        end
      '';
      options.desc = "[F]ile [E]xplorer";
    }

    # Find files
    {
      mode = "n";
      key = "<leader>ff";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.files()
        end
      '';
      options.desc = "[F]ind [F]iles";
    }

    # Recent files
    {
      mode = "n";
      key = "<leader>fr";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.recent()
        end
      '';
      options.desc = "[F]ind [R]ecent files";
    }

    # Find files in the Neovim configuration
    {
      mode = "n";
      key = "<leader>fc";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.files({
            cwd = vim.fn.stdpath("config"),
          })
        end
      '';
      options.desc = "[F]ind [C]onfig files";
    }

    # Find buffers
    {
      mode = "n";
      key = "<leader>fb";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.buffers()
        end
      '';
      options.desc = "[F]ind [B]uffer";
    }

    ## [C]ode

    {
      mode = "n";
      key = "<leader>cd";
      action = lib.nixvim.mkRaw "vim.diagnostic.open_float";
      options.desc = "[C]ode [D]iagnostics";
    }

    {
      mode = "n";
      key = "<leader>cq";
      action = lib.nixvim.mkRaw "vim.diagnostic.setloclist";
      options.desc = "[C]ode diagnostics location list";
    }

    {
      mode = "n";
      key = "<leader>cf";
      action = lib.nixvim.mkRaw ''
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end
      '';
      options.desc = "[C]ode [F]ormat";
    }

    ## [X] Diagnostics
    # All diagnostics in the workspace
    {
      mode = "n";
      key = "<leader>xx";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.diagnostics()
        end
      '';
      options.desc = "All diagnostics";
    }

    # Diagnostics in the current buffer
    {
      mode = "n";
      key = "<leader>xb";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.diagnostics_buffer()
        end
      '';
      options.desc = "[B]uffer diagnostics";
    }

    # Quickfix list
    {
      mode = "n";
      key = "<leader>xq";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.qflist()
        end
      '';
      options.desc = "[Q]uickfix list";
    }

    # Location list
    {
      mode = "n";
      key = "<leader>xl";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.picker.loclist()
        end
      '';
      options.desc = "[L]ocation list";
    }

    ## [B]uffers
    # Delete the current buffer without disrupting the window layout
    {
      mode = "n";
      key = "<leader>bd";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.bufdelete()
        end
      '';
      options.desc = "[B]uffer [D]elete";
    }

    # Delete other buffers
    {
      mode = "n";
      key = "<leader>bo";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.bufdelete.other()
        end
      '';
      options.desc = "[B]uffer Delete [O]thers";
    }

    ## [G]it
    {
      mode = "n";
      key = "<leader>gg";
      action = lib.nixvim.mkRaw ''
        function()
          Snacks.lazygit()
        end
      '';
      options.desc = "[G]it Lazy[G]it";
    }

    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>ghs";
      action = "<cmd>Gitsigns stage_hunk<cr>";
      options.desc = "[S]tage hunk";
    }

    {
      mode = [
        "n"
        "x"
      ];
      key = "<leader>ghr";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options.desc = "[R]eset hunk";
    }

    {
      mode = "n";
      key = "<leader>ghu";
      action = "<cmd>Gitsigns undo_stage_hunk<cr>";
      options.desc = "[U]ndo stage hunk";
    }

    {
      mode = "n";
      key = "<leader>ghp";
      action = "<cmd>Gitsigns preview_hunk_inline<cr>";
      options.desc = "[P]review hunk";
    }

    {
      mode = "n";
      key = "<leader>ghb";
      action = "<cmd>Gitsigns blame_line full=true<cr>";
      options.desc = "[B]lame line";
    }

    {
      mode = "n";
      key = "<leader>ghd";
      action = "<cmd>Gitsigns diffthis<cr>";
      options.desc = "[D]iff file";
    }
  ];
}
