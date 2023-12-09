{...}: {
  hm.programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto";
      hwdec-codecs = "vaapi";
      profile = "gpu-hq";
      video-sync = "display-resample";
      volume = 50;
    };
  };

  hm.services.jellyfin-mpv-shim.enable = true;
}
