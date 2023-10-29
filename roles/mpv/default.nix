{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.mpv;
in {
  options.roles.mpv = {
    enable = mkEnableOption "mpv role";
  };

  config = mkIf cfg.enable {
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
  };
}
