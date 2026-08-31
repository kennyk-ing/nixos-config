{ lib, ... }:
{
  opts = {
    # UI
    number = true;
    relativenumber = true;
    cursorline = true;
    signcolumn = "yes";
    colorcolumn = "81";
    # Hide the command line until it is needed.
    cmdheight = 0;

    # Indentation
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = -1;
    expandtab = true;
    shiftround = true;

    # Wrapped lines
    breakindent = true;
    linebreak = true;

    # Search
    ignorecase = true;
    smartcase = true;

    # Scrolling
    scrolloff = 8;
    sidescrolloff = 4;

    # Splits
    splitright = true;
    splitbelow = true;
    splitkeep = "screen";

    # Editing
    mouse = "a";
    confirm = true;
    undofile = true;

    # System clipboard
    clipboard = "unnamedplus";

    # Responsiveness
    updatetime = 250;
    # Time to wait for a mapped key sequence to complete
    timeoutlen = 300;

    # Whitespace
    list = true;
    listchars = {
      tab = "» ";
      trail = "·";
      nbsp = "␣";
    };

    # Live :substitute preview
    inccommand = "split";

    # Lualine will display the current mode
    showmode = false;

    # Restore the viewport as well as the cursor when navigating jumps
    jumpoptions = "clean,view";

    # Allow blockwise visual selections beyond end-of-line
    virtualedit = "block";

    # Folding
    foldenable = true;

    # Open files with all folds expanded.
    foldlevel = 99;
    foldlevelstart = 99;

    # Don't reserve a permanent fold column.
    foldcolumn = "0";

  };

  autoCmd = [
    {
      event = "TextYankPost";
      desc = "Highlight yanked text";

      callback = lib.nixvim.mkRaw ''
        function()
          vim.hl.on_yank({
            timeout = 200,
          })
        end
      '';
    }
  ];
}
