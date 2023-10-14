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

    services.jellyfin-mpv-shim.enable = true;
  };
}
