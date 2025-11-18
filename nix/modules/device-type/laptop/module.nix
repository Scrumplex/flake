{config, ...}: {
  flake.modules.nixos.laptop = {
    imports = with config.flake.modules.nixos; [base desktop development gaming];

    home-manager.sharedModules = [config.flake.modules.homeManager.laptop];
  };
}
