{
  inputs,
  lib,
  ...
}: {
  imports = builtins.attrValues inputs.scrumpkgs.nixosModules;

  nixpkgs.overlays = lib.mkBefore [
    inputs.self.overlays.default
  ];
}
