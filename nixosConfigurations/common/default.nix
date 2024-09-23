{
  inputs,
  lib,
  ...
}: {
  imports =
    [inputs.agenix.nixosModules.age]
    ++ builtins.attrValues inputs.scrumpkgs.nixosModules;

  nixpkgs.overlays = lib.mkBefore [
    inputs.scrumpkgs.overlays.default
  ];

  _module.args.lib' = inputs.scrumpkgs.lib.scrumplex;
}
