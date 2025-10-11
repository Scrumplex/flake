{config, ...}: {
  flake.modules.nixos.desktop = {
    imports = [config.flake.modules.nixos.base];

    home-manager.sharedModules = [config.flake.modules.homeManager.desktop];
  };
}
