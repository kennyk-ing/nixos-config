{ ... }:

{
  boot = {
    kernelParams = [
      "intel_iommu=on"

      # Intel 82576 dual-port NIC:
      # LAN - 0000:01:00.0
      # WAN - 0000:01:00.1
      #
      # Both functions use 8086:10c9, and no other device on kingdome
      # uses this PCI ID.
      "vfio-pci.ids=8086:10c9"
    ];

    # Load VFIO early so it claims LAN and WAN before the normal igb driver.
    initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
  };

  # If VFIO binding fails, prevent NetworkManager from configuring either port
  # Fail 'closed' instead of failing 'open'
  networking.networkmanager.unmanaged = [
    "enp1s0f0" # LAN
    "enp1s0f1" # WAN
  ];
}
