{config, ...}: {
  flake.modules.nixos."machine-galileo" = {
    imports = [config.flake.modules.nixos."ext-media"];
  };
}
