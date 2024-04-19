{config, ...}: let
  fqdn = "grafana.scrumplex.net";
  addr = with config.services.grafana.settings.server; "${http_addr}:${toString http_port}";
in {
  age.secrets."grafana-smtp-password" = {
    file = ../../secrets/universe/grafana-smtp-password.age;
    owner = config.systemd.services.grafana.serviceConfig.User;
  };

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
    settings = {
      server = {
        http_port = 3050;
        root_url = "https://${fqdn}/";
      };
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
        ];
      };
    };
  };

  services.nginx = {
    upstreams.grafana.servers."${addr}" = {};
    virtualHosts."${fqdn}" = {
      forceSSL = true;
      enableACME = true;
      quic = true;
      http3_hq = true;
      locations."/".proxyPass = "http://grafana";
    };
  };
}
