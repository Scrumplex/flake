{config, ...}: {
  flake.modules.nixos."gaming" = {
    home-manager.sharedModules = [config.flake.modules.homeManager."gaming"];
  };
}
