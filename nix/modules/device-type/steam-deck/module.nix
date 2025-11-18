{config, ...}: {
  flake.modules.nixos.steam-deck = {
    imports = with config.flake.modules.nixos; [base];

    #home-manager.sharedModules = [config.flake.modules.homeManager.steam-deck];
  };
}
