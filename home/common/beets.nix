{
  config,
  nixosConfig,
  pkgs,
  ...
}: {
  xdg.configFile."beets/config.yaml".text = ''
    directory: ${config.home.homeDirectory}/Music
    library: ${config.home.homeDirectory}/Music/musiclibrary.db
    clutter: Thumbs.DB .DS_Store .directory

    import:
      move: yes
      timid: yes
      detail: yes
      bell: yes

    ui:
      color: yes

    plugins: absubmit acousticbrainz chroma duplicates edit fetchart mbcollection mbsync mpdstats mpdupdate replaygain scrub
    include:
      - "${nixosConfig.age.secrets."beets-secrets.yaml".path}"

    mpd:
      host: localhost
      port: ${toString config.services.mpd.network.port}

    replaygain:
      backend: gstreamer
  '';

  systemd.user.services."beets-mpdstats" = {
    Unit = {
      Description = "Beets MPDStats daemon";
      After = ["mpd.service"];
      Requires = ["mpd.service"];
    };
    Service.ExecStart = "${pkgs.beets}/bin/beet mpdstats";
  };

  home.packages = with pkgs; [beets];
}
