{
  config,
  pkgs,
  ...
}: {
  age.secrets."beets-secrets.yaml" = {
    file = ../../secrets/common/beets-secrets.yaml.age;
    owner = config.primaryUser.name;
  };

  hm.programs.beets = {
    enable = true;
    mpdIntegration.enableUpdate = true;
    settings = {
      directory = config.hm.xdg.userDirs.music;
      library = "${config.hm.xdg.userDirs.music}/musiclibrary.db";
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

      include = [config.age.secrets."beets-secrets.yaml".path];
    };
  };
}
