{config, ...}: {
  flake.modules.nixos.raspberry-pi-4 = {
    imports = [config.flake.modules.nixos.headless];
  };
}
