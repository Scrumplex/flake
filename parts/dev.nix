{
  perSystem = {
    config,
    inputs',
    pkgs,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      packages = [self'.formatter inputs'.agenix.packages.agenix pkgs.just pkgs.nix-fast-build pkgs.nix-output-monitor pkgs.opentofu pkgs.nixos-facter];
    };
    formatter = pkgs.alejandra;
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      nil.enable = true;
      prettier = {
        enable = true;
        excludes = ["flake.lock" "facter.json"];
      };
      terraform-format.enable = true;
    };
  };
}
