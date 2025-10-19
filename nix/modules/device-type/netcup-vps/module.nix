{config, ...}: {
  flake.modules.nixos.netcup-vps = {
    imports = [config.flake.modules.nixos.headless];
  };
}
