{
  fpConfig,
  pkgs,
  ...
}: {
  imports = [fpConfig.flake.modules.nixos.ext-postgres];
  services.postgresql.package = pkgs.postgresql_15;
}
