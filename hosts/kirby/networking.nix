{ ... }:

{
  systemd.network.networks."10-lan" = {
    # Using MAC instead of device name because it's a USB device that may move
    matchConfig.MACAddress = "9c:69:d3:81:48:ea";

    networkConfig.DHCP = "ipv4";
  };
}
