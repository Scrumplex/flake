{...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      logviewer = pkgs.python311.pkgs.callPackage ./logviewer {};
    };
  };
  flake.overlays.default = final: prev: {
    logviewer = final.python311.pkgs.callPackage ./logviewer {};
  };
}
