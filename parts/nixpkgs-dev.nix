{
  perSystem = {pkgs, ...}: {
    devShells.nixpkgs = pkgs.mkShell {
      packages = with pkgs; [nixpkgs-fmt nixpkgs-review nix-prefetch-github];
    };
  };
}
