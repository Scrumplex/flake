{...}: {
  services.sabnzbd = {
    enable = true;
    user = "media";
    group = "media";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.sabnzbd = {
      entryPoints = ["localsecure"];
      service = "sabnzbd";
      rule = "Host(`nzb.eclipse.lan`)";
    };
    services.sabnzbd.loadBalancer.servers = [{url = "http://localhost:8888";}];
  };
}
