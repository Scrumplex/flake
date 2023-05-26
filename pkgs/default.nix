self: super: (import ./top-level/all-packages.nix super) // (import ./top-level/overrides.nix self super)
