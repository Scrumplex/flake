{inputs, ...}: {
  flake.modules.nixos.gaming = {
    imports = [
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    ];
  };
}
