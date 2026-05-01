{
  flake.modules.nixos."ext-monitoring" = {
    environment.etc."alloy/self-monitoring.alloy".text = ''
      prometheus.exporter.self "default" {}

      prometheus.scrape "self" {
        targets    = prometheus.exporter.self.default.targets
        forward_to = [otelcol.receiver.prometheus.default.receiver]
      }
    '';
  };
}
