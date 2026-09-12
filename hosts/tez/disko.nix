{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-KLEVV_CRAS_C925_M.2_NVMe_SSD_2TB_2025062101001013";

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
            type = "btrfs";
            extraArgs = [ "-f" ];

            subvolumes = {
              "/root" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/swap" = {
                mountpoint = "/.swapvol";
                swap.swapfile.size = "4G";
              };
            };
          };
        };
      };
    };
  };
}
