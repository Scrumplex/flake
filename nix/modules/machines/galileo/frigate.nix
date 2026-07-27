{config, ...}: let
  fpConfig = config;
in {
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    imports = [fpConfig.flake.modules.nixos."ext-frigate"];

    age.secrets."frigate.env".file = ./frigate.env.age;

    virtualisation.oci-containers.containers."frigate" = {
      image = config.virtualisation.oci-containers.externalImages.images."frigate".ref;

      volumes = [
        "/srv/frigate/media:/media/frigate"
        "/srv/frigate/config:/config"
      ];

      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.frigate.rule" = "Host(`view.galileo.sefa.cloud`)";
        "traefik.http.routers.frigate.entrypoints" = "websecure";
        "traefik.http.routers.frigate.middlewares" = "internal-only@file";
        "traefik.http.services.frigate.loadbalancer.server.port" = "8971";
      };
    };
  };
}
