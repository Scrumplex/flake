{
  perSystem = {pkgs, ...}: {
    packages.run-or-raise = pkgs.callPackage ./_derivation.nix {};
  };

  flake.overlays.run-or-raise = final: _: {
    run-or-raise = final.callPackage ./_derivation.nix {};
  };
}
