{
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.mimir.length = 2;

    services.mimir = {
      enable = true;
      configuration = {
        common.storage = {
          backend = "filesystem";
          #filesystem.dir = "/var/lib/mimir/chunks";
        };
        usage_stats.enabled = false;
        server = {
          http_listen_port = config.alloc.tcpPorts.blocks.mimir.start;
          grpc_listen_port = config.alloc.tcpPorts.blocks.mimir.start + 1;
        };
        ingester.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        distributor.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        query_scheduler.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
        ruler.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
      };
    };
  };
}
