{inputs, ...}: {
  flake.modules.nixos.base = {
    imports = [inputs.run0-sudo-shim.nixosModules.default];
    nixpkgs.overlays = [inputs.run0-sudo-shim.overlays.default];

    security.run0-sudo-shim.enable = true;
  };
}
