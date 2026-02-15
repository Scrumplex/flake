{
  config,
  lib,
  ...
}: let
  fqdn = "nzb.eclipse.sefa.cloud";
in {
  age.secrets."sabnzbd-secrets.ini" = {
    file = ./sabnzbd-secrets.ini.age;
    owner = "media";
    group = "media";
  };

  nixpkgs.allowedUnfreePackageNames = ["unrar"];

  assertions = [
    {
      assertion = lib.versionOlder config.system.stateVersion "26.05";
      message = "sabnzbd configFile null is set. Please remove after changing state version to 26.05";
    }
  ];

  services.sabnzbd = {
    enable = true;
    user = "media";
    group = "media";
    configFile = null; # stateVersion
    settings = {
      misc = {
        port = 8085;
        host_whitelist = fqdn;
        backup_for_duplicates = 1;
        bandwidth_max = "18M";
        bandwidth_perc = 100;
        cache_limit = "1G";
        complete_dir = "/media/nzb/complete";
        direct_unpack_tested = 1;
        download_dir = "/media/nzb/incomplete";
        history_limit = 250;
        history_retention = "";
        history_retention_number = 1;
        queue_limit = 250;
      };
    };
    secretFiles = [
      config.age.secrets."sabnzbd-secrets.ini".path
    ];
  };

  systemd.services.sabnzbd.unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamic.files."sabnzbd".settings.http = {
    routers.sabnzbd = {
      entryPoints = ["websecure"];
      middlewares = ["internal-only"];
      service = "sabnzbd";
      rule = "Host(`${fqdn}`)";
    };
    services.sabnzbd.loadBalancer.servers = [{url = "http://localhost:${toString config.services.sabnzbd.settings.misc.port}";}];
  };
}
