{
  perSystem = {pkgs, ...}: {
    devShells.nixpkgs = pkgs.mkShellNoCC {
      packages = with pkgs; [nixpkgs-fmt nixpkgs-review nix-prefetch-github nix-init];
    };
  };
}
