{
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    package = pkgs.postgresql_16;
    extraPlugins = [config.services.postgresql.package.pkgs.pg_repack];
  };
}
