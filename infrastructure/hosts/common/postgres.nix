{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;

  cfg = config.common.postgresql;
in {
  options.common.postgresql = {
    initScript = mkOption {
      type = types.lines;
      default = "";
      example = ''
        CREATE ROLE "foo";
      '';
    };
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
}
