{lib, ...}: let
  inherit (lib) mkIf mkOption types;
in {
  flake.modules.nixos.ext-postgres = {
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

      alloc.tcpPorts.blocks.prometheus-postgres-exporter.length = 1;
      services.prometheus.exporters.postgres = {
        enable = true;
        runAsLocalSuperUser = true;
        port = config.alloc.tcpPorts.blocks.prometheus-postgres-exporter.start;
      };

      services.alloy.scrape = [
        {
          targets = with config.services.prometheus.exporters.postgres; ["${listenAddress}:${toString port}"];
        }
      ];

      services.borgbackup.jobs.borgbase.exclude = ["/var/lib/postgresql"];
    };
  };
}
