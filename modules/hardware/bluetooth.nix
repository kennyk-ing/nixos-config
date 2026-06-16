{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true; # Often needed for modern headsets
      };
    };
  };

  services.blueman.enable = true; 
}
