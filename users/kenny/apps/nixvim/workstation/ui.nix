{ lib, ... }:
let
  # Shared highlight groups used by both Rainbow Delimiters
  # and indent-blankline. Red is intentionally omitted.
  rainbowHighlights = [
    "RainbowYellow"
    "RainbowBlue"
    "RainbowOrange"
    "RainbowGreen"
    "RainbowViolet"
    "RainbowCyan"
  ];
in
{
  colorschemes.nightfox = {
    enable = true;
    settings.options.transparent = true;
  };
  colorscheme = "carbonfox";

  autoCmd = [
    {
      event = [
        "RecordingEnter"
        "RecordingLeave"
      ];

      callback = lib.nixvim.mkRaw ''
        function()
          vim.schedule(function()
            require("lualine").refresh({
              place = { "statusline" },
            })
          end)
        end
      '';
    }
  ];

  plugins = {
    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          # Use one statusline across the bottom instead of one per window.
          globalstatus = true;
          # Keep MiniFiles from taking over the active statusline context.
          ignore_focus = [
            "mini-files"
          ];
        };

        sections = {
          lualine_x = [
            (lib.nixvim.mkRaw ''
              function()
                local reg = vim.fn.reg_recording()

                if reg == "" then
                  return ""
                end

                return "Recording @" .. reg
              end
            '')

            "encoding"
            "fileformat"
            "filetype"
          ];
        };
      };
    };

    rainbow-delimiters = {
      enable = true;

      settings = {
        highlight = rainbowHighlights;
      };
    };

    indent-blankline = {
      enable = true;

      settings = {
        indent = {
          char = "│";
        };

        scope = {
          enabled = true;
          char = "│";
          show_start = true;
          show_end = true;
          highlight = rainbowHighlights;

          # Nix attribute sets are not treated as lexical scopes by default.
          # Treat { ... } attribute sets as scopes for indent-blankline.
          include = {
            node_type = {
              nix = [
                "attrset_expression"
                "list_expression"
              ];
            };
          };
        };
      };

      # indent-blankline needs these highlight groups to exist
      # before its setup() runs. Build them from Carbonfox's
      # own palette so they stay consistent with the theme.
      luaConfig.pre = ''
        local hooks = require("ibl.hooks")
        local palette = require("nightfox.palette").load("carbonfox")

        hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowYellow", {
            fg = palette.yellow.base,
          })
          vim.api.nvim_set_hl(0, "RainbowBlue", {
            fg = palette.blue.base,
          })
          vim.api.nvim_set_hl(0, "RainbowOrange", {
            fg = palette.orange.base,
          })
          vim.api.nvim_set_hl(0, "RainbowGreen", {
            fg = palette.green.base,
          })
          vim.api.nvim_set_hl(0, "RainbowViolet", {
            fg = palette.magenta.base,
          })
          vim.api.nvim_set_hl(0, "RainbowCyan", {
            fg = palette.cyan.base,
          })
        end)
      '';

      # Make indent-blankline's current scope follow the
      # delimiter color at that nesting level.
      luaConfig.post = ''
        local hooks = require("ibl.hooks")

        hooks.register(
          hooks.type.SCOPE_HIGHLIGHT,
          hooks.builtin.scope_highlight_from_extmark
        )
      '';
    };

    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        spec = [
          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>b" ]
            // {
              group = "buffers";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>c" ]
            // {
              group = "code";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>f" ]
            // {
              group = "file/find";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>g" ]
            // {
              group = "git";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "gs" ]
            // {
              group = "surround";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>q" ]
            // {
              group = "quit/session";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>s" ]
            // {
              group = "search";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>u" ]
            // {
              group = "UI";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>w" ]
            // {
              group = "windows";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "<leader>x" ]
            // {
              group = "problems/lists";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "[" ]
            // {
              group = "previous";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "]" ]
            // {
              group = "next";
            }
          )

          (
            lib.nixvim.listToUnkeyedAttrs [ "g" ]
            // {
              group = "goto";
            }
          )
        ];
      };
    };
  };
}
