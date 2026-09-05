{
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

    # Exit terminal mode
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

    # Windows
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

    # Search and replace word under cursor
    {
      mode = "n";
      key = "<leader>sr";
      action = ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>";
      options.desc = "[S]earch and [R]eplace current word";
    }

    # Files
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
      options.desc = "[F]ile [N]ew";
    }

    # Buffers
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
  ];
}
