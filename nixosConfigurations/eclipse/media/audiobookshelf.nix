{config, ...}: {
  services.audiobookshelf = {
    enable = true;
    port = 23232;
  };

  systemd.services.traefik.unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamicConfigOptions.http = {
    routers.audiobookshelf = {
      entryPoints = ["websecure"];
      service = "audiobookshelf";
      rule = "Host(`audiobookshelf.sefa.cloud`)";
    };
    services.audiobookshelf.loadBalancer.servers = [{url = "http://localhost:${toString config.services.audiobookshelf.port}";}];
  };
}
