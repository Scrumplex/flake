{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
}:

pkgs.mkShell {
  buildInputs = [
    (pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" {})
    pkgs.colmena
  ];
}
