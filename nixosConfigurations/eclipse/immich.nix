{
  config,
  pkgs,
  ...
}: {
  services.immich = {
    enable = true;
    mediaLocation = "/media/immich-library";
    port = 9121;
  };

  # Workaround patch for https://github.com/NixOS/nixpkgs/pull/355266
  systemd.services."immich-server".path = [pkgs.perl];

  users.users.immich.extraGroups = ["video" "render"];

  services.traefik.dynamicConfigOptions.http = {
    routers.immich = {
      entryPoints = ["websecure"];
      service = "immich";
      rule = "Host(`immich.sefa.cloud`)";
    };
    services.immich.loadBalancer.servers = [{url = "http://${config.services.immich.host}:${toString config.services.immich.port}";}];
  };

  services.borgbackup.jobs.borgbase.paths = ["/media/immich-library"];
}
