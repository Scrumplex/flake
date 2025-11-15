{config, ...}: {
  flake.modules.nixos.workstation = {
    imports = [config.flake.modules.nixos.base config.flake.modules.nixos.desktop config.flake.modules.nixos.development];
  };
}
