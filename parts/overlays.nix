{self, ...}: {
  flake.overlays.default = final: prev: (import ../pkgs/top-level/all-packages.nix final);

  perSystem = {pkgs, ...}: {
    # our overlay only has new packages and doesn't use prev
    legacyPackages = self.overlays.default pkgs null;
  };
}
