{ lib, pkgs, ... }:
let
  # Web projects may use either Biome or Prettier.
  # Prefer Biome when both are configured.
  webFormatters = {
    __unkeyed-1 = "biome";
    __unkeyed-2 = "prettier";
    stop_after_first = true;
  };
in
{
  extraPackages = with pkgs; [
    nixfmt

    # Standalone shell scripts may not have a dev shell.
    shellcheck
    shfmt
  ];

  plugins = {
    lspconfig.enable = true;
    schemastore.enable = true;

    blink-cmp = {
      enable = true;

      # Nixvim automatically advertises Blink's completion
      # capabilities to attached LSP servers.
      setupLspCapabilities = true;

      settings = {
        # Blink's recommended Vim-like defaults:
        #   C-y     accept completion
        #   C-n/p   next/previous
        #   C-Space open completion/docs
        #   Tab     snippet navigation
        keymap.preset = "default";

        # Show documentation automatically after briefly
        # selecting a completion item.
        completion.documentation = {
          auto_show = true;
          auto_show_delay_ms = 500;
        };

        # LSP, filesystem paths, snippets, and buffer words.
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        formatters = {
          biome = {
            require_cwd = true;
          };

          prettier = {
            require_cwd = true;
          };
        };

        formatters_by_ft = {
          # Nix
          nix = [ "nixfmt" ];

          # JavaScript / TypeScript / web
          javascript = webFormatters;
          javascriptreact = webFormatters;
          typescript = webFormatters;
          typescriptreact = webFormatters;
          css = webFormatters;
          # Biome's HTML formatting is currently experimental,
          # so keep HTML on Prettier for now.
          html = [ "prettier" ];
          scss = [ "prettier" ];

          # Data formats
          json = webFormatters;
          jsonc = webFormatters;
          yaml = [ "prettier" ];
          toml = [ "taplo" ];

          # Python
          python = [ "ruff_format" ];

          # Shell scripts
          sh = [ "shfmt" ];
        };

        # Format before writing the file.
        # If the configured external formatter is unavailable,
        # use an attached LSP formatter when one exists.
        format_on_save = {
          timeout_ms = 1000;
          lsp_format = "fallback";
        };
      };
    };
  };

  lsp.servers = {
    # Nix
    nixd = {
      enable = true;
      packageFallback = true;
    };

    # Web
    html = {
      enable = true;
      packageFallback = true;
    };

    cssls = {
      enable = true;
      packageFallback = true;
    };

    # JavaScript / TypeScript
    # vtsls is mature and feature-rich. TypeScript's new native
    # Go-based LSP is still in transition, so we'll revisit that later.
    vtsls = {
      enable = true;
      package = pkgs.vtsls;
      packageFallback = true;
    };

    eslint = {
      enable = true;
      packageFallback = true;
    };

    biome = {
      enable = true;
      packageFallback = true;
    };

    # Data formats
    jsonls = {
      enable = true;
      packageFallback = true;
    };

    yamlls = {
      enable = true;
      packageFallback = true;
    };

    # TOML
    taplo = {
      enable = true;
      packageFallback = true;
    };

    # Python
    basedpyright = {
      enable = true;
      packageFallback = true;
    };

    ruff = {
      enable = true;
      packageFallback = true;
    };

    # Shell
    bashls = {
      enable = true;
      packageFallback = true;
    };
  };

  diagnostic.settings = {
    # Show higher-severity diagnostics first.
    severity_sort = true;

    # Keep gutter signs and diagnostic highlighting.
    signs = true;
    underline = true;

    # Don't update diagnostics while actively typing.
    update_in_insert = false;

    # Show inline diagnostic text only for the current line.
    virtual_text = {
      current_line = true;
      spacing = 2;
    };

    # Use a consistent border for diagnostic popups.
    float = {
      border = "rounded";
      source = "if_many";
    };
  };

  # BasedPyright owns Python hover information.
  # Ruff remains responsible for linting, fixes, imports, and formatting.
  autoCmd = [
    {
      event = "LspAttach";
      desc = "Disable Ruff hover in favor of BasedPyright";

      callback = lib.nixvim.mkRaw ''
        function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end
        end
      '';
    }
  ];
}
