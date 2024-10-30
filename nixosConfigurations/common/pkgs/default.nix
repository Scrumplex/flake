{lib, ...}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };

  paramikoOverrides = pyFinal: pyPrev: {
    paramiko = pyPrev.paramiko.overridePythonAttrs (oldAttrs: {
      dependencies =
        oldAttrs.dependencies
        ++ [
          pyFinal.pynacl
        ];
    });
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
        "anydesk"
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

        tandoor-recipes = prev.tandoor-recipes.override {
          python311 = {
            override = attrs: let
              python3 = final.python311.override {
                self = python3;
                packageOverrides = pyFinal: pyPrev: (attrs.packageOverrides pyFinal pyPrev) // (paramikoOverrides pyFinal pyPrev);
              };
            in
              python3;
          };
        };
      })
    ];
  };
}
