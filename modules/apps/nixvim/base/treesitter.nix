{ config, ... }:

{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;
    indent.enable = true;
    folding.enable = true;

    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      # Shell / system
      bash
      nix

      # Neovim
      lua
      vim
      vimdoc
      query
      regex

      # Data / configuration
      json
      toml
      yaml

      # Documentation
      markdown
      markdown_inline
    ];
  };
}
