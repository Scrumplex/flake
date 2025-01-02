{
  config,
  pkgs,
  ...
}: {
  services.opentelemetry-collector = {
    enable = true;
    package = pkgs.opentelemetry-collector-contrib;
    settings = {
      receivers = {
        otlp.protocols.http.endpoint = "localhost:9590";
      };
      processors.batch = {};
      exporters.prometheusremotewrite = {
        endpoint = "http://localhost:9090/api/v1/write";
      };
      service.pipelines.metrics = {
        receivers = ["otlp"];
        processors = ["batch"];
        exporters = ["prometheusremotewrite"];
      };
      service.telemetry.metrics.address = "127.0.0.1:8899";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.otel = {
      entryPoints = ["localsecure"];
      service = "otel";
      rule = "Host(`otel.sefa.cloud`)";
    };
    services.otel.loadBalancer.servers = [{url = "http://${config.services.opentelemetry-collector.settings.receivers.otlp.protocols.http.endpoint}";}];
  };

  services.prometheus = {
    enable = true;
    extraFlags = ["--web.enable-remote-write-receiver"];
  };
}
