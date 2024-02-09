{...}: {
  hm.programs.waybar.extraModules = {
    cameraBlank = {
      enable = true;
      device = "/dev/v4l/by-id/usb-046d_Logitech_Webcam_C925e_D8A39E5F-video-index0";
      blanked.props = {
        auto_exposure = "1";
        exposure_time_absolute = "3";
      };
      unblanked.props = {
        auto_exposure = "3";
      };
    };
    paMute.alsaState = {
      card = "Generic"; # TODO: is there a more unique identifier?
      file = ./asound.state;
    };
  };
}
