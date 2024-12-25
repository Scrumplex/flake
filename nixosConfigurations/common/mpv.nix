{...}: {
  hm.catppuccin.mpv.enable = true;
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

  hm.systemd.user.services."jellyfin-mpv-shim" = {
    Unit.After = ["graphical-session.target"];
    Service.Slice = ["background-graphical.slice"];
  };
}
