{ ... }:

{
  services.nfs.server = {
    enable = true;

    # root_squash prevents the client's root from having root on the server.
    exports = ''
      /srv/storage/hdd1/books 10.0.100.10(ro,sync,root_squash,no_subtree_check)
    '';
  };

  # Never serve the library from the underlying root filesystem
  # if HDD1 failed to mount.
  systemd.services.nfs-server.unitConfig = {
    RequiresMountsFor = [ "/srv/storage/hdd1" ];
    AssertPathIsMountPoint = "/srv/storage/hdd1";
  };
}
