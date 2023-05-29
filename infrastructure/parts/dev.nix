{
  perSystem = {
    config,
    inputs',
    pkgs,
    self',
    ...
  }: {
    pre-commit.settings.hooks.alejandra.enable = true;

    devShells.default = pkgs.mkShell {
      shellHook = ''
        ${config.pre-commit.installationScript}
      '';

      packages = [self'.formatter inputs'.agenix.packages.agenix pkgs.colmena];
    };

    formatter = pkgs.alejandra;
  };
}
