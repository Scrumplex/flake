{...}: {
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
    services.radarr.loadBalancer.servers = [{url = "http://localhost:7878";}];
    services.sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
  };
}
