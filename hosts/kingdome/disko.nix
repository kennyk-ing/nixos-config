{
  disko.devices.disk.main = {
    type = "disk";

    # SK hynix SC311 SATA 128 GB.
    device = "/dev/disk/by-path/pci-0000:00:17.0-ata-5";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };

        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
