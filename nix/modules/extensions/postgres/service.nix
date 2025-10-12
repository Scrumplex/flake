{lib, ...}: let
  inherit (lib) mkIf mkOption types;
in {
  flake.modules.ext-postgres = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.services.postgresql;
  in {
    options.services.postgresql.initScript = mkOption {
      type = types.lines;
      default = "";
      example = ''
        CREATE ROLE "foo";
      '';
    };

    config = {
      services.postgresql = {
        enable = true;
        initialScript = mkIf (cfg.initScript != "") (pkgs.writeText "postgres-init.sql" cfg.initScript);
      };
      services.postgresqlBackup.enable = true;

      services.prometheus = {
        exporters.postgres = {
          enable = true;
          runAsLocalSuperUser = true;
        };
        scrapeConfigs = [
          {
            job_name = "postgres";
            static_configs = [
              {
                targets = ["localhost:${toString config.services.prometheus.exporters.postgres.port}"];
              }
            ];
          }
        ];
      };

      services.borgbackup.jobs.borgbase.exclude = ["/var/lib/postgresql"];
    };
  };
}
