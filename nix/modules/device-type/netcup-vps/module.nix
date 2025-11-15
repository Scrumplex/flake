{config, ...}: {
  flake.modules.nixos.netcup-vps = {
    imports = [config.flake.modules.nixos.base config.flake.modules.nixos.headless];
  };
}
