{
  flake.modules.nixos."machine-galileo" = {
    services.home-assistant.extraComponents = [
      "music_assistant"
    ];

    services.music-assistant = {
      enable = true;
      openFirewall = true;
      providers = [
        "airplay"
        "builtin"
        "fanarttv"
        "jellyfin"
        "listenbrainz_scrobble"
        "lrclib"
        "musicbrainz"
        "sendspin"
        "theaudiodb"
      ];
    };

    services.traefik.dynamic.files."music-assistant".settings.http = {
      routers.music-assistant = {
        entryPoints = ["websecure"];
        service = "music-assistant";
        rule = "Host(`mass.sefa.cloud`)";
      };
      services.music-assistant.loadBalancer.servers = [{url = "http://localhost:8095";}];
    };
  };
}
