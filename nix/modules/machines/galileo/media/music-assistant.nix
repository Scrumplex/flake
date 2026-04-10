{lib, ...}: {
  flake.modules.nixos."machine-galileo" = {
    services.home-assistant.extraComponents = [
      "music_assistant"
    ];

    services.music-assistant = {
      enable = true;
      openFirewall = true;
      providers = [
        "airplay"
        "apple_music"
        "audiobookshelf"
        "builtin"
        "fanarttv"
        "heos"
        "jellyfin"
        "listenbrainz_scrobble"
        "lrclib"
        "musicbrainz"
        "sendspin"
        "theaudiodb"
      ];
    };

    systemd.services."music-assistant".serviceConfig = {
      User = "media";
      Group = "media";
      DynamicUser = lib.mkForce false;
    };

    services.traefik.dynamic.files."music-assistant".settings.http = {
      routers.music-assistant = {
        entryPoints = ["websecure"];
        service = "music-assistant";
        rule = "Host(`mass.sefa.cloud`)";
      };
      services.music-assistant.loadBalancer.servers = [{url = "http://localhost:8095";}];
    };

    services.avahi.enable = true;

    # allow mdns
    networking.firewall.allowedUDPPorts = [5353];
  };
}
