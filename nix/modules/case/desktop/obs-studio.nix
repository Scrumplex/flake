{
  flake.modules.nixos.desktop = {config, ...}: {
    primaryUser.extraGroups = ["video"];

    boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    boot.kernelModules = ["v4l2loopback"];
  };

  flake.modules.homeManager.desktop = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-gstreamer
        obs-vaapi
      ];
    };
  };
}
