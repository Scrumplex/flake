{
  config,
  nixosConfig,
  pkgs,
  ...
}: {
  programs.beets = {
    enable = true;
    package = pkgs.beets-unstable;
    mpdIntegration.enableStats = true;
    mpdIntegration.enableUpdate = true;
    settings = {
      directory = config.xdg.userDirs.music;
      library = "${config.xdg.userDirs.music}/musiclibrary.db";
      clutter = [
        "Thumbs.DB"
        ".DS_Store"
        ".directory"
      ];

      import = {
        move = true;
        timid = true;
        detail = true;
        bell = true;
      };

      ui.color = true;
      plugins = [
        "absubmit"
        "acousticbrainz"
        "chroma"
        "duplicates"
        "edit"
        "fetchart"
        "mbcollection"
        "mbsync"
        "replaygain"
        "scrub"
      ];
      replaygain.backend = "gstreamer";

      include = [nixosConfig.age.secrets."beets-secrets.yaml".path];
    };
  };
}
