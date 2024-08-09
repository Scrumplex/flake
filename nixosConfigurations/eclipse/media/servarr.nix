{config, ...}: {
  services.radarr = {
    enable = true;
    user = "media";
    group = "media";
  };
  services.sonarr = {
    enable = true;
    user = "media";
    group = "media";
  };
  services.prowlarr.enable = true;
  services.bazarr = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.jellyseerr.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    routers.radarr = {
      entryPoints = ["localsecure"];
      service = "radarr";
      rule = "Host(`radarr.eclipse.lan`)";
    };
    routers.sonarr = {
      entryPoints = ["localsecure"];
      service = "sonarr";
      rule = "Host(`sonarr.eclipse.lan`)";
    };
    routers.prowlarr = {
      entryPoints = ["localsecure"];
      service = "prowlarr";
      rule = "Host(`prowlarr.eclipse.lan`)";
    };
    routers.bazarr = {
      entryPoints = ["localsecure"];
      service = "bazarr";
      rule = "Host(`bazarr.eclipse.lan`)";
    };
    routers.jellyseerr = {
      entryPoints = ["websecure"];
      service = "jellyseerr";
      rule = "Host(`request.sefa.cloud`)";
    };
    services.radarr.loadBalancer.servers = [{url = "http://localhost:7878";}];
    services.sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
    services.prowlarr.loadBalancer.servers = [{url = "http://localhost:9696";}];
    services.bazarr.loadBalancer.servers = [{url = "http://localhost:6767";}];
    services.jellyseerr.loadBalancer.servers = [{url = "http://localhost:${toString config.services.jellyseerr.port}";}];
  };
}
