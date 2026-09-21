{ lib, ... }:

{
  services = {
    sonarr = {
      enable = true;
      group = "media";
    };

    radarr = {
      enable = true;
      group = "media";
    };

    prowlarr.enable = true;

    flaresolverr = {
      enable = true;
      openFirewall = false;
    };

    bazarr = {
      enable = true;
      group = "media";
      openFirewall = false;
    };

    seerr = {
      enable = true;
      openFirewall = false;
    };
  };

  systemd.services = {
    sonarr = {
      unitConfig.RequiresMountsFor = [ "/srv/data" ];
      bindsTo = [ "srv-data.mount" ];
      after = [ "srv-data.mount" ];

      serviceConfig.UMask = lib.mkForce "0002";
    };

    radarr = {
      unitConfig.RequiresMountsFor = [ "/srv/data" ];
      bindsTo = [ "srv-data.mount" ];
      after = [ "srv-data.mount" ];

      serviceConfig.UMask = lib.mkForce "0002";
    };

    bazarr = {
      unitConfig.RequiresMountsFor = [ "/srv/data" ];
      bindsTo = [ "srv-data.mount" ];
      after = [ "srv-data.mount" ];

      serviceConfig.UMask = "0002";
    };
  };
}
