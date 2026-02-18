{
  config,
  lib,
  ...
}: let
  fqdn = "grafana.scrumplex.net";
  addr = with config.services.grafana.settings.server; "${http_addr}:${toString http_port}";
in {
  age.secrets."grafana-smtp-password" = {
    file = ../../secrets/universe/grafana-smtp-password.age;
    owner = config.systemd.services.grafana.serviceConfig.User;
  };
  age.secrets."grafana-secret-key" = {
    file = ./grafana-secret-key.age;
    owner = config.systemd.services.grafana.serviceConfig.User;
  };

  services.prometheus = {
    enable = true;

    listenAddress = "127.0.0.1";
    globalConfig.scrape_interval = "15s";

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "processes"
          "systemd"
        ];
        listenAddress = "127.0.0.1";
      };
      systemd.enable = true;
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
      {
        job_name = "systemd";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.systemd.port}"];
          }
        ];
      }
    ];
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_port = 3050;
        root_url = "https://${fqdn}/";
      };
      security.secret_key = "$__file{${config.age.secrets."grafana-secret-key".path}}";
      smtp = {
        enabled = true;
        host = "smtp-relay.brevo.com:587";
        user = "contact@scrumplex.net";
        password = "$__file{${config.age.secrets."grafana-smtp-password".path}}";
        from_address = "notify@sefa.cloud";
      };
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
          {
            name = "Prometheus@eclipse";
            type = "prometheus";
            uid = "prom_eclipse";
            url = "http://10.255.255.12:9090";
          }
        ];
      };
    };
  };

  services.nginx = {
    upstreams.grafana.servers."${addr}" = {};
    virtualHosts."${fqdn}" = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://grafana";
      }
    ];
  };
}
