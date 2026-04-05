{config, ...}: {
  alloc.tcpPorts.blocks.audiobookshelf.length = 1;

  services.audiobookshelf = {
    enable = true;
    port = config.alloc.tcpPorts.blocks.audiobookshelf.start;
  };

  systemd.services.traefik.unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamic.files."audiobookshelf".settings.http = {
    routers.audiobookshelf = {
      entryPoints = ["websecure"];
      service = "audiobookshelf";
      rule = "Host(`audiobookshelf.sefa.cloud`)";
    };
    services.audiobookshelf.loadBalancer.servers = [{url = "http://localhost:${toString config.services.audiobookshelf.port}";}];
  };
}
