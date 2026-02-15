{
  services.traefik.dynamic.files."nextcloud".settings.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      service = "nextcloud";
      rule = "Host(`box.sefa.cloud`)";
    };
    services.nextcloud.loadBalancer.servers = [{url = "http://localhost:7701";}];
  };
}
