{...}: let
  fqdn = "auth.scrumplex.net";
in {
  flake.modules.nixos."machine-universe" = {config, ...}: {
    age.secrets."pocket-id-encryption-key" = {
      file = ./encryption-key.age;
      owner = config.services.pocket-id.user;
      inherit (config.services.pocket-id) group;
    };

    services.postgresql = {
      ensureUsers = [
        {
          name = config.services.pocket-id.user;
          ensureDBOwnership = true;
        }
      ];
      ensureDatabases = [config.services.pocket-id.user];
    };

    alloc.tcpPorts.blocks.pocket-id.length = 1;

    services.pocket-id = {
      enable = true;

      settings = {
        DB_CONNECTION_STRING = "postgres:///pocket-id?host=/run/postgresql";
        ANALYTICS_DISABLED = true;
        APP_URL = "https://${fqdn}";
        TRUST_PROXY = true;
        ENCRYPTION_KEY_FILE = config.age.secrets."pocket-id-encryption-key".path;
        HOST = "::1";
        PORT = config.alloc.tcpPorts.blocks.pocket-id.start;
      };
    };

    services.traefik.dynamic.files."pocket-id".settings.http = {
      routers.pocket-id = {
        entryPoints = ["websecure"];
        service = "pocket-id";
        rule = "Host(`${fqdn}`)";
      };
      services.pocket-id.loadBalancer.servers = [{url = "http://[::1]:${toString config.services.pocket-id.settings.PORT}";}];
    };
  };
}
