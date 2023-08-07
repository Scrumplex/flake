{lib, ...}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = lib.mkAfter [
      (final: prev: {
        bemoji = prev.bemoji.override {
          menuTool = final.fuzzel-dmenu-shim;
        };

        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        element-desktop = prev.element-desktop.override {electron = final.electron_24;};

        # https://github.com/NixOS/nixpkgs/pull/247691
        jellyfin-mpv-shim = prev.jellyfin-mpv-shim.overrideAttrs (prev: {
          postPatch =
            prev.postPatch
            + ''
              # python-mpv renamed to mpv with 1.0.4
              substituteInPlace setup.py \
                --replace "python-mpv" "mpv" \
                --replace "mpv-jsonipc" "python_mpv_jsonipc"
            '';
        });

        ncmpcpp = prev.ncmpcpp.override {
          visualizerSupport = true;
        };

        prismlauncher = prev.prismlauncher.override {
          glfw = final.glfwUnstable;
        };

        spamassassin = prev.spamassassin.overrideAttrs (prev: {doCheck = false;});
      })
    ];
  };
}
