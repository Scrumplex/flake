{config, ...}: {
  services.postgresql.enable = true;
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
}
