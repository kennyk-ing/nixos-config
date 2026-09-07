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

    galaxyA52 = {
      id = "4S427ET-DVF7KYE-7R5YSG3-NV4JL3V-J3EJL7G-IIJ3IAF-C2JOQQR-XWMNUQ7";
      addresses = [ "tcp://kenny-galaxy-a52-5g:22000" ];
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

      folders = {
        documents = {
          id = "documents";
          label = "Documents";
          path = "~/Documents";

          devices = builtins.filter (device: device != hostName) [
            "kirby"
            "woo"
          ];

          versioning = {
            type = "staggered";
            params = {
              maxAge = "15552000"; # only keep for 180 days
            };
          };
        };
      };

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
