{
  flake.modules.nixos."ext-frigate" = {config, ...}: {
    virtualisation.oci-containers.containers."frigate" = {
      environmentFiles = [
        config.age.secrets."frigate.env".path
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
  };
}
