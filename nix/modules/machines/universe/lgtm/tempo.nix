{
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.tempo.length = 4;

    services.tempo = {
      enable = true;
      settings = {
        server = {
          http_listen_port = config.alloc.tcpPorts.blocks.tempo.start;
          grpc_listen_port = config.alloc.tcpPorts.blocks.tempo.start + 1;
        };
        distributor.receivers.otlp.protocols = {
          grpc = "localhost:${toString (config.alloc.tcpPorts.blocks.tempo.start + 2)}";
          http = "localhost:${toString (config.alloc.tcpPorts.blocks.tempo.start + 3)}";
        };
        metrics_generator = {
          ring = {
            kvstore.store = "inmemory";
            instance_addr = "127.0.0.1";
          };
          traces_storage.path = "/var/lib/tempo/generator/traces";
        };
        compactor.ring = {
          kvstore.store = "inmemory";
          instance_addr = "127.0.0.1";
        };
      };
    };
  };
}
