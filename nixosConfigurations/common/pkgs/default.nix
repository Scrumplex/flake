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

        # https://github.com/NixOS/nixpkgs/pull/297158
        waybar = prev.waybar.override {
          wireplumber = final.wireplumber.overrideAttrs (attrs: rec {
            version = "0.4.17";
            src = final.fetchFromGitLab {
              domain = "gitlab.freedesktop.org";
              owner = "pipewire";
              repo = "wireplumber";
              rev = version;
              hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
            };
          });
        };
      })
    ];
  };
}
