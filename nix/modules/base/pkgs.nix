{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos."base" = {
    nixpkgs.overlays = lib.mkBefore [
      inputs.self.overlays.default
    ];
  };
}
