{config, ...}: {
  flake.modules.nixos.development = {
    home-manager.sharedModules = [config.flake.modules.homeManager.development];
  };
}
