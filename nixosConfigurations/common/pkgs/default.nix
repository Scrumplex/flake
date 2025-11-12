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
        "steam"
        "steam-unwrapped"
        "teamspeak-server" # universe TS3 Server
        "unrar" # eclipse sabnzbd
        "anydesk"
        "epsonscan2" # printing module
      ])
      || builtins.any (lib.flip lib.hasPrefix (lib.getName pkg)) ["cuda" "libcu" "libn"];

    overlays = lib.mkAfter [
      (_: prev: {
        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };
      })
      (final: prev: {
        # Remove once https://github.com/NixOS/nixpkgs/pull/460637 reaches unstable
        element-web-unwrapped = prev.element-web-unwrapped.override {
          jitsi-meet = final.jitsi-meet.overrideAttrs (previousAttrs: {
            meta = removeAttrs previousAttrs.meta ["knownVulnerabilities"];
          });
        };
      })
    ];
  };
}
