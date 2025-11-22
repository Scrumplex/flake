{...}: {
  services.sabnzbd = {
    enable = true;
    user = "media";
    group = "media";
  };

  systemd.services.sabnzbd.unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamicConfigOptions.http = {
    routers.sabnzbd = {
      entryPoints = ["localsecure"];
      service = "sabnzbd";
      rule = "Host(`nzb.eclipse.sefa.cloud`)";
    };
    services.sabnzbd.loadBalancer.servers = [{url = "http://localhost:8888";}];
  };
}
