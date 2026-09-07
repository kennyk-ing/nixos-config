{ osConfig, ... }:
let
  hostName = osConfig.networking.hostName;

  devices = {
    kirby = {
      id = "BVID26R-K3BOS46-DVPTYR2-HMYMVMZ-TPQSGN6-OYC75VV-6BYFOOW-CIPMCAE";
      addresses = [ "tcp://kirby:22000" ];
    };

    woo = {
      id = "XR5CXOS-PRPUYVZ-GZD6H5Y-K46HJK5-UD3HVWE-PEH5L7V-G5SCEHH-OJR4MQE";
      addresses = [ "tcp://woo:22000" ];
    };
  };

  remoteDevices = removeAttrs devices [ hostName ];
in
{
  services.syncthing = {
    enable = osConfig.mySystem.services.syncthing.enable;

    overrideDevices = true;
    overrideFolders = true;

    settings = {
      devices = remoteDevices;
      folders = { };

      options = {
        listenAddresses = [
          "tcp://0.0.0.0:22000"
        ];

        globalAnnounceEnabled = false;
        localAnnounceEnabled = false;
        natEnabled = false;
        relaysEnabled = false;
      };
    };
  };
}
