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

  services.smartd = {
    autodetect = false;

    devices = [
      {
        # WD Blue 4 TB — first Sunday of the month
        device = "/dev/disk/by-id/ata-WDC_WD40EZRZ-00GXCB0_WD-WCC7K4LEJX02";
        options = "-a -s (S/../../7/02|L/../0[1-7]/7/02)";
      }
      {
        # WD Black 4 TB — second Sunday of the month
        device = "/dev/disk/by-id/ata-WDC_WD4005FZBX-00K5WB0_VBHLU7DF";
        options = "-a -s (S/../../7/02|L/../(0[8-9]|1[0-4])/7/02)";
      }
      {
        # Seagate BarraCuda 8 TB — third Sunday of the month
        device = "/dev/disk/by-id/ata-ST8000DM004-2U9188_ZR162LQH";
        options = "-a -s (S/../../7/02|L/../(1[5-9]|2[0-1])/7/02)";
      }
      {
        # KLEVV CRAS C925 2 TB NVMe — fourth Sunday of the month
        device = "/dev/disk/by-id/nvme-KLEVV_CRAS_C925_M.2_NVMe_SSD_2TB_2025062101001013_1";
        options = "-a -s (S/../../7/02|L/../2[2-8]/7/02)";
      }
    ];
  };
}
