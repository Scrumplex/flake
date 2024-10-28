{
  perSystem = {pkgs, ...}: {
    devShells.nixpkgs = pkgs.mkShellNoCC {
      packages = with pkgs; [nixpkgs-fmt nixfmt-rfc-style nixpkgs-review nix-prefetch-github nix-init nix-update];
    };
  };
}
