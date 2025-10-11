{
  config,
  lib,
  ...
}: {
  services.jellyfin = {
    enable = true;
    user = "media";
    group = "media";
  };

  systemd.services.jellyfin.unitConfig.RequiredMountsFor = "/media";

  users.users.${config.services.jellyfin.user}.extraGroups =
    ["video" "render"]
    ++ lib.optional config.services.syncthing.enable config.services.syncthing.group;

  services.traefik.dynamicConfigOptions.http = {
    routers.jellyfin = {
      entryPoints = ["websecure"];
      service = "jellyfin";
      rule = "Host(`jellyfin.sefa.cloud`)";
    };
    services.jellyfin.loadBalancer.servers = [{url = "http://localhost:8096";}];
  };
}
