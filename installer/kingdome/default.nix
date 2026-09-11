{
  inputs,
  lib,
  modulesPath,
  pkgs,
  self,
  ...
}:

let
  target = self.nixosConfigurations.kingdome;

  flakeOutPaths =
    let
      collector =
        parent:
        map (
          child: [ child.outPath ] ++ (if child ? inputs && child.inputs != { } then collector child else [ ])
        ) (lib.attrValues parent.inputs);
    in
    lib.unique (lib.flatten (collector self));

  dependencies = [
    target.config.system.build.toplevel
    target.config.system.build.diskoScript
    target.config.system.build.diskoScript.drvPath
    target.pkgs.stdenv.drvPath
    target.pkgs.perlPackages.ConfigIniFiles
    target.pkgs.perlPackages.FileSlurp

    (target.pkgs.closureInfo { rootPaths = [ ]; }).drvPath
  ]
  ++ flakeOutPaths;

  closureInfo = pkgs.closureInfo {
    rootPaths = dependencies;
  };

  disko = inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.etc = {
    "install-closure".source = "${closureInfo}/store-paths";
    "nixos-config".source = self.outPath;

    "kingdome-recovery/preflight.sh" = {
      source = ./preflight.sh;
      mode = "0555";
    };

    "kingdome-recovery/install.sh" = {
      source = ./install.sh;
      mode = "0555";
    };

    "kingdome-recovery/README.md".source = ./README.md;

    "kingdome-recovery/hodor.xml".source = ../../hosts/kingdome/hodor.xml;
  };

  environment.systemPackages = [
    disko
    pkgs.cryptsetup
    pkgs.openssh
    pkgs.pciutils
    pkgs.util-linux
  ];

  boot = {
    kernelParams = [ "intel_iommu=on" ];
    zfs.forceImportRoot = false;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  isoImage.squashfsCompression = "zstd -Xcompression-level 6";
}
