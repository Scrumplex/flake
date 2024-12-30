{...}: {
  programs.evolution.enable = true;
  nixpkgs.overlays = [
    (final: prev: {
      evolution = prev.evolution.override {spamassassin = final.hello;};
    })
  ];
}
