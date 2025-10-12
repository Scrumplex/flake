{config, ...}: {
  flake.modules.nixos.workstation = {
    imports = [config.flake.modules.nixos.desktop];

    #home-manager.sharedModules = [config.flake.modules.homeManager.workstation];
  };
}
