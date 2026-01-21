{config, ...}: let
  fqdn = "nzb.eclipse.sefa.cloud";
in {
  age.secrets."sabnzbd-secrets.ini" = {
    file = ./sabnzbd-secrets.ini.age;
    owner = "media";
    group = "media";
  };

  services.sabnzbd = {
    enable = true;
    user = "media";
    group = "media";
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

  services.traefik.dynamicConfigOptions.http = {
    routers.sabnzbd = {
      entryPoints = ["localsecure"];
      service = "sabnzbd";
      rule = "Host(`${fqdn}`)";
    };
    services.sabnzbd.loadBalancer.servers = [{url = "http://localhost:${toString config.services.sabnzbd.settings.misc.port}";}];
  };
}
