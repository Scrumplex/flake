{
  config,
  pkgs,
  ...
}: let
  settings = {
    cameras = {
      front = {
        ffmpeg.inputs = [
          {
            path = "rtsp://127.0.0.1:8554/front";
            roles = ["record"];
          }
          {
            path = "rtsp://127.0.0.1:8554/front_sub";
            roles = ["detect"];
          }
        ];
        motion.mask = [
          "0.941,0.748,0.907,0.44,0.873,0.249,0.69,0.297,0.52,0.352,0.337,0.452,0.233,0.504,0.151,0.527,0.092,0.529,0.078,0.721,0,0.713,0,0,1,0,1,0.742"
        ];
      };
      back = {
        ffmpeg.inputs = [
          {
            path = "rtsp://127.0.0.1:8554/back";
            roles = ["record"];
          }
          {
            path = "rtsp://127.0.0.1:8554/back_sub";
            roles = ["detect"];
          }
        ];
        motion.mask = [
          "1,0,0.994,0.282,0.58,0.149,0.421,0.119,0.29,0.163,0.273,0.33,0.166,0.436,0,0.758,0,0"
        ];
      };
      back2 = {
        ffmpeg.inputs = [
          {
            path = "rtsp://127.0.0.1:8554/back2";
            roles = ["record"];
          }
          {
            path = "rtsp://127.0.0.1:8554/back2_sub";
            roles = ["detect"];
          }
        ];
      };
      door = {
        ffmpeg.inputs = [
          {
            path = "rtsp://127.0.0.1:8554/door";
            roles = ["record"];
          }
          {
            path = "rtsp://127.0.0.1:8554/door_sub";
            roles = ["detect"];
          }
        ];
        motion.mask = [
          "516,68,503,167,797,232,831,88" # Fenster links
          "1258,189,1206,354,1009,284,1056,129" # Fenster rechts
          "464,0,447,125,347,155,228,131,183,222,126,245,0,255,0,0" # Himmel
        ];
      };
    };
    detect = {
      width = 1280;
      height = 720;
    };
    detectors.coral = {
      type = "edgetpu";
      device = "usb";
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
        back2 = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.213:554/Streaming/Channels/101";
        back2_sub = "rtsp://stream:{FRIGATE_RTSP_PASSWORD}@10.10.10.213:554/Streaming/Channels/102";
      };
    };
    # camera feed timestamp
    motion.mask = "0,0,0,54,371,54,371,0";
    mqtt = {
      enabled = config.services.mosquitto.enable;
      host = "eclipse.sefa.cloud";
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
    tls.enabled = false;
  };
  configFile = (pkgs.formats.yaml {}).generate "frigate.yml" settings;
in {
  age.secrets."frigate.env".file = ../../secrets/eclipse/frigate.env.age;

  virtualisation.oci-containers.containers."frigate" = {
    image = config.virtualisation.oci-containers.externalImages.images."frigate".ref;
    environmentFiles = [
      config.age.secrets."frigate.env".path
    ];
    volumes = [
      "/media/frigate:/media/frigate"
      "/srv/frigate:/config"
      "${configFile}:/config/config.yml:ro"
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
      "--shm-size=128m"
    ];
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.frigate.rule" = "Host(`view.eclipse.sefa.cloud`)";
      "traefik.http.routers.frigate.entrypoints" = "localsecure";
      "traefik.http.services.frigate.loadbalancer.server.port" = "8971";
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
}
