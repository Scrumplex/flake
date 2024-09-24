{
  config,
  inputs,
  ...
}: {
  imports = [
    "${inputs.nixpkgs-immich}/nixos/modules/services/web-apps/immich.nix"
  ];
  services.immich = {
    enable = true;
    package = inputs.nixpkgs-immich.legacyPackages.x86_64-linux.immich;
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
