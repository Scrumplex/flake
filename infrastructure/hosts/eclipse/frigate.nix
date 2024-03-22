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
      back.ffmpeg.inputs = [
        {
          path = "rtsp://127.0.0.1:8554/back";
          roles = ["record"];
        }
        {
          path = "rtsp://127.0.0.1:8554/back_sub";
          roles = ["detect"];
        }
      ];
      door.ffmpeg.inputs = [
        {
          path = "rtsp://127.0.0.1:8554/door";
          roles = ["record"];
        }
        {
          path = "rtsp://127.0.0.1:8554/door_sub";
          roles = ["detect"];
        }
      ];
    };
    detect = {
      width = 1280;
      height = 720;
    };
    detectors.ov = {
      type = "openvino";
      device = "AUTO";
      model.path = "/openvino-model/ssdlite_mobilenet_v2.xml";
    };
    environment_vars.LIBVA_DRIVER_NAME = "radeonsi";
    ffmpeg.hwaccel_args = "preset-vaapi";
    go2rtc = {
      rtsp = {
        username = "stream";
        password = "{FRIGATE_RTSP_PASSWORD}";
      };
      streams = {
        front = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.210:554/Streaming/Channels/101";
        front_sub = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.210:554/Streaming/Channels/102";
        door = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.211:554/Streaming/Channels/101";
        door_sub = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.211:554/Streaming/Channels/102";
        back = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.212:554/Streaming/Channels/101";
        back_sub = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.212:554/Streaming/Channels/102";
      };
    };
    model = {
      width = 300;
      height = 300;
      input_tensor = "nchw";
      input_pixel_format = "bgr";
      labelmap_path = "/openvino-model/coco_91cl_bkgr.txt";
    };
    motion.mask = "0,0,0,54,371,54,371,0";
    mqtt = {
      enabled = config.services.mosquitto.enable;
      host = "eclipse.lan";
      user = "user";
      password = "{FRIGATE_MQTT_PASSWORD}";
    };
    record = {
      enabled = true;
      retain = {
        days = 7;
        mode = "all";
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
      "1935:1935" # RTMP
      "5000:5000" # API
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
      1935
      5000
      8554
      8555
    ];
    allowedUDPPorts = [
      8555
    ];
  };

  services.traefik.dynamicConfigOptions.http.middlewares.frigate-auth.basicAuth.usersFile = config.age.secrets."frigate-users".path;
}
