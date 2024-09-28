{config, ...}: {
  services.immich = {
    enable = true;
    mediaLocation = "/media/immich-library";
    port = 9121;
  };

  users.users.immich.extraGroups = ["video" "render"];

  services.traefik.dynamicConfigOptions.http = {
    routers.immich = {
      entryPoints = ["websecure"];
      service = "immich";
      rule = "Host(`immich.sefa.cloud`)";
    };
    services.immich.loadBalancer.servers = [{url = "http://${config.services.immich.host}:${toString config.services.immich.port}";}];
  };
}
