{
  lib,
  osConfig,
  pkgs,
  ...
}:

{
  # Workaround for ONLYOFFICE failing to read Nix store symlinks
  config = lib.mkIf osConfig.mySystem.apps.office.enable {
    home.activation.onlyofficeFonts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      font_dir="$HOME/.local/share/fonts/onlyoffice"

      ${pkgs.coreutils}/bin/mkdir -p "$font_dir"
      ${pkgs.coreutils}/bin/rm -f "$font_dir"/*

      ${pkgs.findutils}/bin/find ${pkgs.corefonts}/share/fonts \
        -type f -iname "*.ttf" \
        -exec ${pkgs.coreutils}/bin/cp -L {} "$font_dir/" \;

      ${pkgs.findutils}/bin/find ${pkgs.vista-fonts}/share/fonts \
        -type f -iname "*.ttf" \
        -exec ${pkgs.coreutils}/bin/cp -L {} "$font_dir/" \;

      ${pkgs.coreutils}/bin/chmod 0644 "$font_dir"/* 2>/dev/null || true
    '';
  };
}
