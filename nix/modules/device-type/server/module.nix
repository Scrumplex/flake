{config, ...}: {
  flake.modules.nixos.server = {
    imports = [config.flake.modules.nixos.headless];
  };
}
