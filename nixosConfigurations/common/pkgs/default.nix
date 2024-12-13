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
      (builtins.elem (lib.getName pkg) [
        "discord-canary"
        "libXNVCtrl"
        "minecraft-server"
        "samsung-unified-linux-driver"
        "shipwright"
        "steam"
        "steam-unwrapped"
        "teamspeak-server" # universe TS3 Server
        "unrar" # eclipse sabnzbd
        "anydesk"
      ])
      || builtins.any (lib.flip lib.hasPrefix (lib.getName pkg)) ["cuda" "libcu" "libn"];

    config.permittedInsecurePackages = [
      "aspnetcore-runtime-6.0.36"
      "dotnet-sdk-6.0.428"
    ];

    overlays = lib.mkAfter [
      (final: prev: {
        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };
      })
    ];
  };
}
