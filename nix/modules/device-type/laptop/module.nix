{config, ...}: {
  flake.modules.nixos.laptop = {
    imports = [config.flake.modules.nixos.base config.flake.modules.nixos.desktop config.flake.modules.nixos.development];

    home-manager.sharedModules = [config.flake.modules.homeManager.laptop];
  };
}
