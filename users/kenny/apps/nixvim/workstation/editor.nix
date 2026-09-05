{ config, ... }:

{
  plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
    # JavaScript / TypeScript
    javascript
    typescript
    tsx
    html
    css

    # Python
    python
  ];
}
