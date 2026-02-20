{lib, ...}: let
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

    services.pocket-id = {
      enable = true;

      settings = {
        DB_CONNECTION_STRING = "postgres:///pocket-id?host=/run/postgresql";
        ANALYTICS_DISABLED = true;
        APP_URL = "https://${fqdn}";
        TRUST_PROXY = true;
        ENCRYPTION_KEY_FILE = config.age.secrets."pocket-id-encryption-key".path;
        HOST = "::1";
        PORT = 8003;
      };
    };

    services.nginx = {
      upstreams.pocket-id.servers."[::1]:8003" = {};
      virtualHosts."${fqdn}" = lib.mkMerge [
        config.common.nginx.vHost
        config.common.nginx.sslVHost
        {
          locations."/".proxyPass = "http://pocket-id";
        }
      ];
    };
  };
}
