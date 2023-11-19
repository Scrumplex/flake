{lib, ...}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "discord-canary"
        "samsung-unified-linux-driver"
        "steam"
        "steam-original"
        "steam-run"
      ];

    overlays = lib.mkAfter [
      (final: prev: {
        bemoji = prev.bemoji.override {
          menuTool = final.fuzzel-dmenu-shim;
        };

        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };

        prismlauncher = prev.prismlauncher.override {
          glfw = final.glfwUnstable;
        };
      })
    ];
  };
}
