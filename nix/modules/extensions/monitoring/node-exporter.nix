{
  flake.modules.nixos."ext-monitoring" = {config, ...}: {
    services.prometheus.exporters.node.enable = true;

    services.alloy.scrape = [
      {
        targets = with config.services.prometheus.exporters.node; ["${listenAddress}:${toString port}"];
      }
    ];
  };
}
