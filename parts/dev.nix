{
  perSystem = {
    config,
    inputs',
    lib,
    pkgs,
    self',
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      packages =
        [self'.formatter pkgs.just pkgs.nix-output-monitor]
        ++ lib.optionals (builtins.elem system lib.platforms.darwin) [
          inputs'.nix-darwin.packages.darwin-rebuild
        ];
    };
    formatter = pkgs.alejandra;
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      nil.enable = true;
      prettier = {
        enable = true;
        excludes = ["flake.lock"];
      };
    };
  };
}
