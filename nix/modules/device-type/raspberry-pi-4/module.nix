{config, ...}: {
  flake.modules.nixos.raspberry-pi-4 = {
    imports = [config.flake.modules.nixos.base config.flake.modules.nixos.headless];
  };
}
