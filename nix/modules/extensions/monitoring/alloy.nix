{
  flake.modules.nixos."ext-monitoring" = {config, ...}: {
    age.secrets."alloy.env".file = ./alloy.env.age;

    services.alloy = {
      enable = true;
      environmentFile = config.age.secrets."alloy.env".path;
    };

    systemd.services."alloy".environment.HOSTNAME = config.networking.hostName;

    environment.etc."alloy/remotes.alloy".text = ''
      prometheus.remote_write "default" {
        endpoint {
          name = "grafana-cloud"
          url = "https://prometheus-prod-65-prod-eu-west-2.grafana.net/api/prom/push"

          basic_auth {
            username = sys.env("GCLOUD_MIMIR_USERNAME")
            password = sys.env("GCLOUD_RW_TOKEN")
          }
        }
      }

      prometheus.relabel "default" {
        rule {
          target_label = "instance"
          replacement  = constants.hostname
        }
        rule {
          target_label = "cluster"
          replacement  = "primary"
        }
        forward_to = [prometheus.remote_write.default.receiver]
      }

      loki.write "default" {
        endpoint {
          url = "https://logs-prod-012.grafana.net/loki/api/v1/push"

          basic_auth {
            username = sys.env("GCLOUD_LOKI_USERNAME")
            password = sys.env("GCLOUD_RW_TOKEN")
          }
        }
      }
    '';
  };
}
