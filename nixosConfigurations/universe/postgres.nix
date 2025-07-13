{
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    package = pkgs.postgresql_16;
    extensions = ps: with ps; [pg_repack];
  };
}
