{
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.loki.length = 2;

    services.loki = {
      enable = true;
      configuration = {
        # Basic stuff
        auth_enabled = false;
        server = {
          http_listen_port = config.alloc.tcpPorts.blocks.loki.start;
          grpc_listen_port = config.alloc.tcpPorts.blocks.loki.start + 1;
        };
        common = {
          path_prefix = config.services.loki.dataDir;
          storage.filesystem = {
            chunks_directory = "${config.services.loki.dataDir}/chunks";
            rules_directory = "${config.services.loki.dataDir}/rules";
          };
          replication_factor = 1;
          ring = {
            kvstore.store = "inmemory";
            instance_addr = "127.0.0.1";
          };
        };

        ingester.chunk_encoding = "snappy";

        limits_config = {
          retention_period = "90d";
          ingestion_burst_size_mb = 16;
          reject_old_samples = true;
          reject_old_samples_max_age = "12h";
        };

        table_manager = {
          retention_deletes_enabled = true;
          retention_period = "90d";
        };

        compactor = {
          retention_enabled = true;
          working_directory = "${config.services.loki.dataDir}/compactor";
          delete_request_store = "filesystem";
        };

        schema_config.configs = [
          {
            from = "2026-05-14";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index.prefix = "index_";
            index.period = "24h";
          }
        ];

        query_range.cache_results = true;
      };
    };
  };
}
