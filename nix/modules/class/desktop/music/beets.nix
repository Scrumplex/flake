{config, ...}: {
  flake.modules.nixos.desktop = {
    age.secrets."beets-secrets.yaml" = {
      file = ./beets-secrets.yaml.age;
      owner = config.flake.meta.username;
    };
  };

  flake.modules.homeManager.desktop = {
    config,
    osConfig,
    ...
  }: {
    programs.beets = {
      enable = true;
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
          "chroma"
          "duplicates"
          "edit"
          "fetchart"
          "mbcollection"
          "mbsync"
          "musicbrainz"
          "replaygain"
          "scrub"
        ];
        replaygain.backend = "gstreamer";

        include = [osConfig.age.secrets."beets-secrets.yaml".path];
      };
    };
  };
}
