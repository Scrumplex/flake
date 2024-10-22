{lib, ...}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  nixpkgs = {
    # TODO: split this out into an option
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord"
        "libXNVCtrl"
        "samsung-unified-linux-driver"
        "shipwright"
        "steam"
        "steam-unwrapped"
        "teamspeak-server" # universe TS3 Server
        "unrar" # eclipse sabnzbd
      ];

    overlays = lib.mkAfter [
      (final: prev: {
        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        evolution = prev.evolution.override {spamassassin = final.hello;};

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };
      })
    ];
  };
}
