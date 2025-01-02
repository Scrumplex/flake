{
  services.ustreamer = {
    enable = true;
    autoStart = false;
    device = "/dev/v4l/by-id/usb-046d_Logitech_Webcam_C925e_D8A39E5F-video-index0";
    extraArgs = [
      "--resolution=1280x720"
      "--desired-fps=20"
      "--encoder=HW"
      "--format=MJPEG"
    ];
  };

  networking.firewall.allowedTCPPorts = [8080];
}
