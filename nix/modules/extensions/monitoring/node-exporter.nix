{
  flake.modules.nixos."ext-monitoring" = {config, ...}: {
    alloc.tcpPorts.blocks.prometheus-node-exporter.length = 1;

    services.prometheus.exporters.node = {
      enable = true;
      port = config.alloc.tcpPorts.blocks.prometheus-node-exporter.start;
      enabledCollectors = [
        "processes"
        "systemd"
      ];
    };

    environment.etc."alloy/node-exporter.alloy".text = with config.services.prometheus.exporters.node; ''
      prometheus.scrape "integrations_node_exporter" {
        targets    = [
          {"__address__" = "${listenAddress}:${toString port}"},
        ]

        forward_to = [prometheus.relabel.integrations_node_exporter.receiver]
      }

      prometheus.relabel "integrations_node_exporter" {
        forward_to = [prometheus.relabel.default.receiver]

        rule {
          target_label = "job"
          replacement = "integrations/node_exporter"
        }
      }
    '';
  };
}
