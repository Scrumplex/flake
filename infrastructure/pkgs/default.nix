{...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      modmail = pkgs.python3.pkgs.callPackage ./modmail {inherit (config.packages) lottie natural;};
      lottie = pkgs.python3.pkgs.callPackage ./python3-lottie {};
      natural = pkgs.python3.pkgs.callPackage ./python3-natural {};
    };
  };
  flake.overlays.default = final: prev: {
    modmail = final.python3.pkgs.callPackage ./modmail {};

    python311 = prev.python311.override {
      self = final.python311;
      packageOverrides = pFinal: pPrev: {
        lottie = pFinal.callPackage ./python3-lottie {};
        natural = pFinal.callPackage ./python3-natural {};
      };
    };
    python3 = final.python311;
    python3Packages = final.python311.pkgs;
  };
}
