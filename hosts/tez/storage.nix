{
  fileSystems = {
    "/srv/storage/hdd1" = {
      # WD40EZRZ-00GXCB0 — 4 TB
      device = "/dev/disk/by-uuid/e49a47c8-9090-4102-9fd8-f30558221ac6";
      fsType = "ext4";
      options = [
        "nofail"
        "noatime"
      ];
    };

    "/srv/storage/hdd2" = {
      # ST8000DM004-2U9188 — 8 TB
      device = "/dev/disk/by-uuid/db2bb1db-a825-4630-95e4-1e6f2cb38057";
      fsType = "ext4";
      options = [
        "nofail"
        "noatime"
      ];
    };

    "/srv/storage/hdd3" = {
      # WD4005FZBX-00K5WB0 — 4 TB
      device = "/dev/disk/by-uuid/a2b6e021-a319-4294-b21d-0cc4628fcf7d";
      fsType = "ext4";
      options = [
        "nofail"
        "noatime"
      ];
    };
  };
}
