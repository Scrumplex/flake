{config, ...}: {
  age.secrets."frigate.env".file = ../../secrets/eclipse/frigate.env.age;

  virtualisation.oci-containers.containers."frigate" = {
    image = config.virtualisation.oci-containers.externalImages.images."frigate".ref;
    environmentFiles = [
      config.age.secrets."frigate.env".path
    ];
    volumes = [
      "/media/frigate:/media/frigate"
      "/srv/frigate:/config"
    ];
    ports = [
      "1935:1935" # RTMP
      "5000:5000" # API
      "8554:8554" # RTSP feeds
      "8555:8555/tcp" # WebRTC
      "8555:8555/udp" # WebRTC
    ];
    extraOptions = [
      "--mount=type=tmpfs,destination=/tmp/cache,tmpfs-size=2G"
      "--device=/dev/bus/usb:/dev/bus/usb"
      "--device=/dev/dri:/dev/dri"
      "--privileged"
      "--shm-size=256m"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.frigate.rule" = "Host(`view.sefa.cloud`)";
      "traefik.http.routers.frigate.entrypoints" = "websecure";
      "traefik.http.services.frigate.loadbalancer.server.port" = "8971";
    };
  };

  systemd.services."docker-frigate".unitConfig.RequiresMountsFor = ["/media"];

  networking.firewall = {
    allowedTCPPorts = [
      1935
      5000
      8554
      8555
    ];
    allowedUDPPorts = [
      8555
    ];
  };
}
