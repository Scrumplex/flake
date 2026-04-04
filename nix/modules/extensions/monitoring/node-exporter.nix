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

    services.alloy.scrape = [
      {
        targets = with config.services.prometheus.exporters.node; ["${listenAddress}:${toString port}"];
      }
    ];
  };
}
