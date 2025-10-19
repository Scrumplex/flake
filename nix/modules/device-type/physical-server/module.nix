{config, ...}: {
  flake.modules.nixos.physical-server = {
    imports = [config.flake.modules.nixos.headless];
  };
}
