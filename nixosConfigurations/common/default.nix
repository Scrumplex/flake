{
  inputs,
  lib,
  ...
}: {
  imports =
    [inputs.agenix.nixosModules.age inputs.catppuccin.nixosModules.catppuccin]
    ++ builtins.attrValues inputs.scrumpkgs.nixosModules;

  catppuccin = {
    flavor = "mocha";
    accent = "blue";
  };

  nixpkgs.overlays = lib.mkBefore [
    inputs.scrumpkgs.overlays.default
    inputs.self.overlays.default
  ];

  _module.args.lib' = inputs.scrumpkgs.lib.scrumplex;
}
