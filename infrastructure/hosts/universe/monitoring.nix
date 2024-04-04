{config, ...}: let
  fqdn = "grafana.scrumplex.net";
in {
  common.traefik.enableMetrics = true;

  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    retentionTime = "30d";

    exporters.node = {
      enable = true;
      enabledCollectors = [
        "processes"
        "systemd"
      ];
      listenAddress = "127.0.0.1";
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 3050;
      root_url = "https://${fqdn}/";
    };

    provision = {
      enable = true;
      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "Prometheus@universe";
            type = "prometheus";
            uid = "prom_universe";
            url = "http://localhost:${toString config.services.prometheus.port}";
            isDefault = true;
          }
        ];
      };
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.grafana = {
      entryPoints = ["websecure"];
      service = "grafana";
      rule = "Host(`${fqdn}`)";
    };
    services.grafana.loadBalancer.servers = [{url = with config.services.grafana.settings.server; "http://${http_addr}:${toString http_port}";}];
  };
}
