{
  flake.modules.nixos."machine-universe" = {
    services.pocket-id.settings = {
      TRACING_ENABLED = true;
      METRICS_ENABLED = true;
      OTEL_EXPORTER_OTLP_ENDPOINT = "http://localhost:4318";
      OTEL_LOGS_EXPORTER = "otlp";
      OTEL_METRICS_EXPORTER = "otlp";
      OTEL_TRACES_EXPORTER = "otlp";
    };
  };
}
