{
  config,
  pkgs,
  ...
}: let
  settings = {
    cameras = {
      front.ffmpeg.inputs = [
        {
          path = "rtsp://127.0.0.1:8554/front";
          roles = ["record"];
        }
        {
          path = "rtsp://127.0.0.1:8554/front_sub";
          roles = ["detect"];
        }
      ];
    };
    detect = {
      width = 1280;
      height = 720;
    };
    environment_vars.LIBVA_DRIVER_NAME = "radeonsi";
    ffmpeg.hwaccel_args = "preset-vaapi";
    go2rtc.streams = {
      front = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.210:554/Streaming/Channels/101";
      front_sub = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.210:554/Streaming/Channels/102";
    };
    mqtt.enabled = false;
    record = {
      enabled = true;
      retain = {
        days = 14;
        mode = "motion";
      };
      events.retain = {
        default = 30;
        mode = "motion";
      };
    };
  };
  configFile = (pkgs.formats.yaml {}).generate "frigate.yml" settings;
in {
  age.secrets."frigate.env".file = ../../secrets/eclipse/frigate.env.age;
  age.secrets."frigate-users" = {
    file = ../../secrets/eclipse/frigate-users.age;
    owner = "traefik";
    group = "traefik";
  };

  virtualisation.oci-containers.containers."frigate" = {
    image = config.virtualisation.oci-containers.externalImages.images."frigate".ref;
    environmentFiles = [
      config.age.secrets."frigate.env".path
    ];
    volumes = [
      "/media/frigate:/media/frigate"
      "/srv/frigate:/config"
      "${configFile}:/config/config.yml"
    ];
    ports = [
      "8554:8554" # RTSP feeds
      "8555:8555/tcp" # WebRTC
      "8555:8555/udp" # WebRTC
    ];
    extraOptions = [
      "--device=/dev/bus/usb:/dev/bus/usb"
      "--device=/dev/dri:/dev/dri"
      "--privileged"
      "--shm-size=128m"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.frigate.rule" = "Host(`view.sefa.cloud`)";
      "traefik.http.routers.frigate.entrypoints" = "websecure";
      "traefik.http.routers.frigate.middlewares" = "frigate-auth@file";
      "traefik.http.services.frigate.loadbalancer.server.port" = "5000";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      8554
      8555
    ];
    allowedUDPPorts = [
      8555
    ];
  };

  services.traefik.dynamicConfigOptions.http.middlewares.frigate-auth.basicAuth.usersFile = config.age.secrets."frigate-users".path;
}
