{config, ...}: {
  flake.modules.nixos.vr = {
    home-manager.sharedModules = [config.flake.modules.homeManager.vr];
  };
}
