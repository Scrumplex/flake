{
  perSystem = {
    pkgs,
    config',
    ...
  }: {
    packages.termapp = pkgs.callPackage ./_derivation.nix {
      inherit (config') run-or-raise;
    };
  };

  flake.overlays.termapp = final: _: {
    termapp = final.callPackage ./_derivation.nix {};
  };
}
