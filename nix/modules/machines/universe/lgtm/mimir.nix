{
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.mimir.length = 3;

    services.mimir = {
      enable = true;
      configuration = {
        common.storage = {
          backend = "filesystem";
          #filesystem.dir = "/var/lib/mimir/chunks";
        };
        usage_stats.enabled = false;
        server = {
          http_listen_port = config.alloc.tcpPorts.blocks.mimir.start;
          grpc_listen_port = config.alloc.tcpPorts.blocks.mimir.start + 1;
        };
        ingester.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        distributor.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        query_scheduler.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        ruler.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        memberlist = {
          bind_port = config.alloc.tcpPorts.blocks.mimir.start + 2;
          advertise_port = config.alloc.tcpPorts.blocks.mimir.start + 3;
        };
      };
    };

    environment.etc."alloy/lgtm-mimir.alloy".text = ''
      otelcol.exporter.prometheus "lgtm" {
        forward_to = [prometheus.remote_write.lgtm_mimir.receiver]
      }

      prometheus.remote_write "lgtm_mimir" {
        endpoint {
          url = "localhost:${toString config.services.mimir.configuration.server.http_listen_port}"
          headers = {
            "X-Scope-OrgID" = "primary",
          }
        }
      }
    '';

    services.grafana.provision.datasources.settings = {
      apiVersion = 1;

      datasources = [
        {
          name = "Mimir";
          uid = "mimir";
          type = "prometheus";
          jsonData = {
            prometheusType = "mimir";
            httpHeaderName1 = "X-Scope-OrgID";
          };
          secureJsonData.httpHeaderValue1 = "primary";
          url = "http://localhost:${toString config.services.mimir.configuration.server.http_listen_port}/prometheus";
        }
      ];
    };
  };
}
