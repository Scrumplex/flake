fself: _:
with fself; {
  bobthefisher = callPackage ./bobthefisher.nix {};

  # Seems like themes don't work here :(
  # catppuccin-fish = callPackage ./catppuccin-fish.nix {};

  fzf = callPackage ./fzf.nix {};

  humantime-fish = callPackage ./humantime-fish.nix {};

  z = callPackage ./z.nix {};
}
