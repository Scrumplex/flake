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
          grpc.endpoint = "localhost:${toString (config.alloc.tcpPorts.blocks.tempo.start + 2)}";
          http.endpoint = "localhost:${toString (config.alloc.tcpPorts.blocks.tempo.start + 3)}";
        };
        storage.trace = {
          backend = "local";
          wal.path = "/var/lib/tempo/wal";
          local.path = "/var/lib/tempo/blocks";
        };
      };
    };
  };
}
