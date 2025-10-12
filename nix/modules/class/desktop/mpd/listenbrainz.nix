{config, ...}: {
  flake.modules.nixos.desktop = {
    age.secrets."listenbrainz-token" = {
      file = ./listenbrainz-token.age;
      owner = config.flake.meta.username;
    };
  };

  flake.modules.homeManager.desktop = {osConfig, ...}: {
    services.listenbrainz-mpd = {
      enable = true;
      settings.submission.token_file = osConfig.age.secrets."listenbrainz-token".path;
    };
  };
}
