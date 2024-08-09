{...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      modmail = pkgs.python311.pkgs.callPackage ./modmail {inherit (config.packages) lottie natural;};
      logviewer = pkgs.python311.pkgs.callPackage ./logviewer {inherit (config.packages) natural;};
      lottie = pkgs.python311.pkgs.callPackage ./python3-lottie {};
      natural = pkgs.python311.pkgs.callPackage ./python3-natural {};
    };
  };
  flake.overlays.default = final: prev: {
    modmail = final.python311Modmail.pkgs.callPackage ./modmail {};
    logviewer = final.python311Modmail.pkgs.callPackage ./logviewer {};

    python311Modmail = prev.python311.override {
      self = final.python311;
      packageOverrides = pFinal: pPrev: {
        lottie = pFinal.callPackage ./python3-lottie {};
        natural = pFinal.callPackage ./python3-natural {};
      };
    };
  };
}
