{config, ...}: {
  flake.modules.nixos.laptop = {
    imports = [config.flake.modules.nixos.desktop];

    home-manager.sharedModules = [config.flake.modules.homeManager.laptop];
  };
}
