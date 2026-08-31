{ lib, ... }:

{
  # Leader keys
  globals = {
    mapleader = " ";
    maplocalleader = "\\";
  };

  keymaps = [
    # Quit
    {
      mode = "n";
      key = "<leader>qq";
      action = "<cmd>q<cr>";
      options.desc = "[Q]uick [Q]uit";
    }

    # Clear search highlighting
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<cr>";
      options.desc = "Clear search highlight";
    }

    # Terminal
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n>";
      options.desc = "Exit terminal mode";
    }

    # Quick insert-mode escape
    {
      mode = "i";
      key = "jk";
      action = "<Esc>";
      options.desc = "Exit insert mode";
    }

    # Move lines
    {
      mode = "n";
      key = "<A-j>";
      action = "<cmd>execute 'move .+' . v:count1<cr>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==";
      options.desc = "Move line up";
    }
    {
      mode = "i";
      key = "<A-j>";
      action = "<Esc><cmd>move .+1<cr>==gi";
      options.desc = "Move line down";
    }
    {
      mode = "i";
      key = "<A-k>";
      action = "<Esc><cmd>move .-2<cr>==gi";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv";
      options.desc = "Move selection up";
    }

    # Join lines without moving the cursor
    {
      mode = "n";
      key = "J";
      action = "mzJ`z";
      options.desc = "Join lines without moving cursor";
    }

    # Keep cursor centered when scrolling
    {
      mode = "n";
      key = "<C-d>";
      action = "<C-d>zz";
      options.desc = "Scroll down and center cursor";
    }
    {
      mode = "n";
      key = "<C-u>";
      action = "<C-u>zz";
      options.desc = "Scroll up and center cursor";
    }

    # Keep search results centered
    {
      mode = "n";
      key = "n";
      action = "nzzzv";
      options.desc = "Next search result and center";
    }
    {
      mode = "n";
      key = "N";
      action = "Nzzzv";
      options.desc = "Previous search result and center";
    }

    # Window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Go to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Go to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Go to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Go to right window";
    }

    ## [W]indows
    {
      mode = "n";
      key = "<leader>wv";
      action = "<C-w>v";
      options.desc = "Split window vertically";
    }
    {
      mode = "n";
      key = "<leader>wh";
      action = "<C-w>s";
      options.desc = "Split window horizontally";
    }
    {
      mode = "n";
      key = "<leader>wd";
      action = "<cmd>close<cr>";
      options.desc = "[W]indow [D]elete";
    }
    {
      mode = "n";
      key = "<leader>we";
      action = "<C-w>=";
      options.desc = "[W]indow resize [E]qually";
    }
    {
      mode = "n";
      key = "<C-Up>";
      action = "<cmd>resize +2<cr>";
      options.desc = "Increase window height";
    }

    {
      mode = "n";
      key = "<C-Down>";
      action = "<cmd>resize -2<cr>";
      options.desc = "Decrease window height";
    }

    {
      mode = "n";
      key = "<C-Left>";
      action = "<cmd>vertical resize -2<cr>";
      options.desc = "Decrease window width";
    }

    {
      mode = "n";
      key = "<C-Right>";
      action = "<cmd>vertical resize +2<cr>";
      options.desc = "Increase window width";
    }

    ## [S]earch
    # Search and replace word under cursor
    {
      mode = "n";
      key = "<leader>sr";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
      options.desc = "[S]earch and [R]eplace current word";
    }

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
    # File Save
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>write<cr>";
      options.desc = "[F]ile [S]ave";
    }
    {
      mode = "n";
      key = "<leader>fn";
      action = "<cmd>enew<cr>";
      options.desc = "[N]ew file";
    }

    # File Explorer
    {
      mode = "n";
      key = "<leader>fe";

      action = lib.nixvim.mkRaw ''
        function()
          local MiniFiles = require("mini.files")

          -- If MiniFiles is already open, close it.
          -- If it wasn't open, close() returns nil and we open it instead.
          if MiniFiles.close() == nil then
            local path = vim.api.nvim_buf_get_name(0)

            -- Unnamed buffers have no file path, so fall back to
            -- MiniFiles' default behavior of opening the current directory.
            if path == "" then
              path = nil
            end

            -- Open MiniFiles focused on the current file when possible.
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
    # All diagnostics in the workspace.
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

    # Diagnostics in the current buffer.
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

    # Quickfix list.
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

    # Location list.
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
    {
      mode = "n";
      key = "<leader>bb";
      action = "<cmd>buffer #<cr>";
      options.desc = "Last buffer";
    }
    {
      mode = "n";
      key = "[b";
      action = "<cmd>bprevious<cr>";
      options.desc = "Previous buffer";
    }
    {
      mode = "n";
      key = "]b";
      action = "<cmd>bnext<cr>";
      options.desc = "Next buffer";
    }
    # Delete the current buffer without disrupting the window layout.
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
