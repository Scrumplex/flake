{pkgs, ...}: {
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      processors.batch = {};
      exporters.otlphttp.endpoint = "https://otel.eclipse.sefa.cloud";
      service.pipelines.metrics = {
        receivers = ["prometheus"];
        processors = ["batch"];
        exporters = ["otlphttp"];
      };
    };
  };
}
