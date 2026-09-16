{ pkgs, ... }:

{
  extraPackages = with pkgs; [
    nixfmt
    shfmt
    taplo
  ];

  plugins = {
    lspconfig.enable = true;

    blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        keymap.preset = "default";

        completion.documentation = {
          auto_show = true;
          auto_show_delay_ms = 500;
        };

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
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          sh = [ "shfmt" ];
          toml = [ "taplo" ];
        };

        format_on_save = {
          timeout_ms = 1000;
          lsp_format = "fallback";
        };

        notify_no_formatters = false;
      };
    };
  };

  # Configure nixd, but obtain the executable from PATH.
  # The nixos-config dev shell already provides it.
  lsp.servers.nixd = {
    enable = true;
    package = null;
  };

  diagnostic.settings = {
    severity_sort = true;
    signs = true;
    underline = true;
    update_in_insert = false;

    virtual_text = {
      current_line = true;
      spacing = 2;
    };

    float = {
      border = "rounded";
      source = "if_many";
    };
  };
}
