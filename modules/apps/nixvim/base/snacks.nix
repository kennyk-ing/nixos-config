{ pkgs, ... }:

{
  # Disable Snacks animations globally.
  globals.snacks_animate = false;

  # External tools used by Snacks picker.
  extraPackages = with pkgs; [
    fd
    ripgrep
    lazygit
  ];

  plugins.snacks = {
    enable = true;
    autoLoad = true;

    settings = {
      bigfile.enabled = true;
      input.enabled = true;
      notifier.enabled = true;
      picker.enabled = true;
      quickfile.enabled = true;
      words.enabled = true;

      lazygit = {
        configure = true;
      };
    };
  };
}
