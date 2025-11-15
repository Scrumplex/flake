{config, ...}: {
  flake.modules.nixos.base = {
    home-manager.sharedModules = [config.flake.modules.homeManager.base];
  };
}
