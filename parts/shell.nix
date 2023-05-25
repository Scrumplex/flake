{
  perSystem = {
    config,
    inputs',
    pkgs,
    self',
    ...
  }: {
    devShells.default = pkgs.mkShell {
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      packages = [self'.formatter inputs'.agenix.packages.agenix];
    };
  };
}
