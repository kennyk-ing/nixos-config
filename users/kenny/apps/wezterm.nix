{ ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ../files/wezterm.lua;
  };
}
