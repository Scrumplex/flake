{config, ...}: {
  services.immich = {
    enable = true;
    mediaLocation = "/media/immich-library";
    port = 9121;
  };

  users.users.immich.extraGroups = ["video" "render"];

  systemd.services."immich-server".unitConfig.RequiresMountsFor = ["/media"];
  systemd.services."immich-machine-learning".unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamic.files."immich".settings.http = {
    routers.immich = {
      entryPoints = ["websecure"];
      service = "immich";
      rule = "Host(`immich.sefa.cloud`)";
    };
    services.immich.loadBalancer.servers = [{url = "http://${config.services.immich.host}:${toString config.services.immich.port}";}];
  };

  services.borgbackup.jobs.borgbase.paths = ["/media/immich-library"];
}
