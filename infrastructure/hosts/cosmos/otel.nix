{pkgs, ...}: {
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      processors.batch = {};
      exporters.otlphttp.endpoint = "https://otel.eclipse.lan";
      service.pipelines.metrics = {
        receivers = ["prometheus"];
        processors = ["batch"];
        exporters = ["otlphttp"];
      };
    };
  };
}
