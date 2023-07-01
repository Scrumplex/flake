{...}: let
  mkDiscordOverride = p:
    p.override {
      withOpenASAR = true;
      withVencord = true;
    };
in {
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      (final: prev: {
        # https://github.com/NixOS/nixpkgs/pull/240720
        beets = prev.beets.overrideAttrs (previousAttrs: {
          patches =
            previousAttrs.patches
            ++ [
              ./beets-remove-failing-embedart-test.patch
            ];
        });

        discord = mkDiscordOverride prev.discord;
        discord-canary = mkDiscordOverride prev.discord-canary;
        discord-ptb = mkDiscordOverride prev.discord-ptb;

        element-desktop = prev.element-desktop.override {electron = final.electron_24;};

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
