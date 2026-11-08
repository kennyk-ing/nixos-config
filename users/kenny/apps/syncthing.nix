{ osConfig, ... }:
let
  hostName = osConfig.networking.hostName;

  devices = {
    earl = {
      id = "GH5R2ET-MYQGDOM-BXXW3PD-4N26JCD-QK6T7QA-JGNYT5J-I53W6BX-MHEETAM";
      addresses = [ "tcp://earl.home.kinghq.net:22000" ];
    };

    tez = {
      id = "3ZNJCVZ-IEMPBV3-362K7VA-VLNYUWJ-6FZYTVG-VCTYWHK-VCMUPT5-6X6ESAF";
      addresses = [ "tcp://tez.home.kinghq.net:22000" ];
    };

    woo = {
      id = "XR5CXOS-PRPUYVZ-GZD6H5Y-K46HJK5-UD3HVWE-PEH5L7V-G5SCEHH-OJR4MQE";
      addresses = [ "tcp://woo.home.kinghq.net:22000" ];
    };

    galaxyA52 = {
      id = "4S427ET-DVF7KYE-7R5YSG3-NV4JL3V-J3EJL7G-IIJ3IAF-C2JOQQR-XWMNUQ7";
      addresses = [ "tcp://kenny-galaxy-a52-5g:22000" ];
    };
  };

  remoteDevices = removeAttrs devices [ hostName ];

  defaultVersioning = {
    type = "staggered";
    params.maxAge = "15552000"; # 180 days
  };
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
          label = "Documents";
          path = "~/Documents";
          devices = builtins.filter (device: device != hostName) [
            "earl"
            "tez"
            "woo"
          ];
          versioning = defaultVersioning;
        };

        org = {
          label = "Org (Emacs)";
          path = "~/org";
          devices = builtins.filter (device: device != hostName) [
            "earl"
            "tez"
            "woo"
          ];
          versioning = defaultVersioning;
        };

        doom = {
          label = "Doom (Emacs)";
          path = "~/.config/doom";
          devices = builtins.filter (device: device != hostName) [
            "earl"
            "tez"
            "woo"
          ];
          versioning = defaultVersioning;
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

        # Disable usage reporting
        urAccepted = -1;
      };
    };
  };
}
