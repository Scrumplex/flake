{config, ...}: {
  flake.modules.nixos."machine-universe" = {
    imports = [config.flake.modules.nixos."ext-traefik"];
  };
}
