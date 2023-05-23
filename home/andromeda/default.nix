{...}: {
  imports = [./borg.nix ./dev.nix];

  s.waybar.cameraBlank.cameraPath = "/dev/v4l/by-id/usb-046d_Logitech_Webcam_C925e_D8A39E5F-video-index0";
}
