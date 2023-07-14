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
