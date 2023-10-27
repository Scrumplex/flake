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
        [self'.formatter inputs'.agenix.packages.agenix pkgs.just pkgs.jinja2-cli]
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
