{ ... }:

{
  # Essential for Wi-Fi and GPU drivers
  hardware.enableRedistributableFirmware = true;

  # Allows you to update BIOS/Motherboard firmware via terminal
  services.fwupd.enable = true;
}
