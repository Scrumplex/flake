{config, ...}: {
  age.secrets."frigate.env".file = ../../secrets/eclipse/frigate.env.age;

  virtualisation.oci-containers.containers."frigate" = {
    image = config.virtualisation.oci-containers.externalImages.images."frigate".ref;

    volumes = [
      "/media/frigate:/media/frigate"
      "/srv/frigate:/config"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.frigate.rule" = "Host(`view.sefa.cloud`)";
      "traefik.http.routers.frigate.entrypoints" = "websecure";
      "traefik.http.services.frigate.loadbalancer.server.port" = "8971";
    };
  };

  systemd.services."docker-frigate".unitConfig.RequiresMountsFor = ["/media"];
}
