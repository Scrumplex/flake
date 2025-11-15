{...}: {
  flake.modules.homeManager.desktop = {
    catppuccin.mpv.enable = true;

    programs.mpv = {
      enable = true;
      config = {
        hwdec = "auto";
        hwdec-codecs = "vaapi";
        profile = "gpu-hq";
        video-sync = "display-resample";
        volume = 50;
      };
    };
  };
}
