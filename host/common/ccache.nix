{config, ...}: {
  programs.ccache = {
    enable = true;
    cacheDir = "/nix/var/cache/ccache";
    packageNames = [
      "prismlauncher"
    ];
  };
  nix.settings.extra-sandbox-paths = [config.programs.ccache.cacheDir];
}
