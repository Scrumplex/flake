{
  flake.modules.nixos."machine-universe" = {
    environment.etc."alloy/lgtm-common.alloy".text = ''
      otelcol.processor.interval "lgtm" {
        output {
          metrics = [otelcol.processor.batch.lgtm.input]
        }
      }

      otelcol.processor.batch "lgtm" {
        output {
          logs    = [otelcol.exporter.loki.lgtm.input]
          metrics = [otelcol.exporter.prometheus.lgtm.input]
          traces  = [otelcol.exporter.otlp.lgtm_tempo.input]
        }
      }
    '';
  };
}
