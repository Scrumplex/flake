{config, ...}: {
  services.actual = {
    enable = true;
    settings.hostname = "127.0.0.1";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.actual = {
      entryPoints = ["websecure"];
      service = "actual";
      rule = "Host(`actual.sefa.cloud`)";
    };
    services.actual.loadBalancer.servers = [{url = "http://${config.services.actual.settings.hostname}:${toString config.services.actual.settings.port}";}];
  };
}
