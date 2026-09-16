{ lib, pkgs, ... }:

let
  # Prefer Biome when both are configured.
  webFormatters = {
    __unkeyed-1 = "biome";
    __unkeyed-2 = "prettier";
    stop_after_first = true;
  };
in
{
  extraPackages = with pkgs; [
    shellcheck
  ];

  plugins = {
    schemastore.enable = true;

    conform-nvim.settings = {
      formatters = {
        biome.require_cwd = true;
        prettier.require_cwd = true;
      };

      formatters_by_ft = {
        # JavaScript / TypeScript / web
        javascript = webFormatters;
        javascriptreact = webFormatters;
        typescript = webFormatters;
        typescriptreact = webFormatters;
        css = webFormatters;

        html = [ "prettier" ];
        scss = [ "prettier" ];

        # Data formats
        json = webFormatters;
        jsonc = webFormatters;
        yaml = [ "prettier" ];

        # Python
        python = [ "ruff_format" ];
      };
    };
  };

  lsp.servers = {
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

  # BasedPyright handles Python hover information.
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
