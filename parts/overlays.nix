{
  flake.overlays.default = import ../pkgs;

  perSystem = {pkgs, ...}: {
    legacyPackages = import ../pkgs/top-level/all-packages.nix pkgs;
  };
}
