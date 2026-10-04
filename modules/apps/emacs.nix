{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mySystem.apps.emacs;

  medicalDictionary = pkgs.stdenvNoCC.mkDerivation {
    pname = "aspell-dict-en-medical";
    version = "4.1.8";

    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/streetsidesoftware/cspell-dicts/1c78d684d46705953c354d55b729f6cbbca18e1d/dictionaries/medicalterms/src/wordlist-medicalterms-en/wordlist.txt";
      hash = "sha256-5gt98kgrKnZ1G+JQEXIGxa97V7V7cdmO986sESd7tp8=";
    };

    dontUnpack = true;

    nativeBuildInputs = [
      (pkgs.aspellWithDicts (dicts: [ dicts.en ]))
    ];

    buildPhase = ''
      runHook preBuild

      grep -a -v '#' "$src" \
        | grep -a -v '/' \
        | aspell create \
            --dont-validate-words \
            --lang=en \
            master ./en-medical.rws

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      install -Dm444 en-medical.rws \
        "$out/lib/aspell/en-medical.rws"

      runHook postInstall
    '';

    meta = {
      description = "English medical terminology dictionary for Aspell";
      homepage = "https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries/medicalterms";
      license = lib.licenses.gpl3Plus;
    };
  };
in
{
  options.mySystem.apps.emacs = {
    enable = lib.mkEnableOption "Emacs and Doom dependencies";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
      ripgrep
      fd

      # Doom
      pandoc
      shellcheck

      # Org-roam
      sqlite

      # Spell checking
      (aspellWithDicts (
        dicts: with dicts; [
          en
          en-computers
          en-science
          medicalDictionary
        ]
      ))
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.sauce-code-pro
      symbola
    ];
  };
}
