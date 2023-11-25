{config, ...}: {
  services.jellyfin.enable = true;

  users.users.${config.services.jellyfin.user}.extraGroups = ["video" "render"];

  services.traefik.dynamicConfigOptions.http = {
    routers.jellyfin = {
      entryPoints = ["websecure"];
      service = "jellyfin";
      rule = "Host(`jellyfin.sefa.cloud`)";
    };
    services.jellyfin.loadBalancer.servers = [{url = "http://localhost:8096";}];
  };
}
