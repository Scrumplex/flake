{
  flake.modules.nixos."ext-monitoring" = {config, ...}: {
    age.secrets."alloy.env".file = ./alloy.env.age;

    services.alloy = {
      enable = true;
      environmentFile = config.age.secrets."alloy.env".path;
    };

    systemd.services."alloy".environment.HOSTNAME = config.networking.hostName;

    environment.etc."alloy/receiver.alloy".text = ''
      otelcol.receiver.prometheus "default" {
        output {
          metrics = [otelcol.processor.attributes.default.input]
        }
      }

      otelcol.receiver.otlp "default" {
        grpc { }
        http { }

        output {
          logs    = [otelcol.processor.attributes.default.input]
          metrics = [otelcol.processor.attributes.default.input]
          traces  = [otelcol.processor.attributes.default.input]
        }
      }
    '';

    environment.etc."alloy/grafana-cloud.alloy".text = ''
      otelcol.processor.attributes "default" {
        action {
          key = "host.name"
          action = "upsert"
          value = constants.hostname
        }

        output {
          logs    = [otelcol.processor.batch.default.input]
          metrics = [otelcol.processor.batch.default.input]
          traces  = [otelcol.processor.batch.default.input]
        }
      }

      otelcol.processor.batch "default" {
        output {
          logs    = [otelcol.exporter.otlphttp.gcloud.input]
          metrics = [otelcol.exporter.otlphttp.gcloud.input]
          traces  = [otelcol.exporter.otlphttp.gcloud.input]
        }
      }

      otelcol.exporter.otlphttp "gcloud" {
        client {
          endpoint = sys.env("GCLOUD_OTLP_ENDPOINT")
          auth = otelcol.auth.basic.gcloud.handler
        }
      }

      otelcol.auth.basic "gcloud" {
        username = sys.env("GCLOUD_OTLP_USERNAME")
        password = sys.env("GCLOUD_OTLP_PASSWORD")
      }
    '';
  };
}
