{
  flake.modules.nixos."ext-monitoring" = {config, ...}: {
    alloc.tcpPorts.blocks.prometheus-systemd-exporter.length = 1;

    services.prometheus.exporters.systemd = {
      enable = true;
      port = config.alloc.tcpPorts.blocks.prometheus-systemd-exporter.start;
    };

    services.alloy.scrape = [
      {
        targets = with config.services.prometheus.exporters.systemd; ["${listenAddress}:${toString port}"];
      }
    ];
  };
}
