{config, ...}: {
  age.secrets."firefly-iii.key" = {
    file = ../../secrets/eclipse/firefly-iii.key.age;
    owner = config.services.firefly-iii.user;
    inherit (config.services.firefly-iii) group;
  };
  age.secrets."firefly-iii-token" = {
    file = ../../secrets/eclipse/firefly-iii-token.age;
    owner = config.services.firefly-iii-data-importer.user;
    inherit (config.services.firefly-iii-data-importer) group;
  };
  age.secrets."firefly-iii-nordigen.key" = {
    file = ../../secrets/eclipse/firefly-iii-nordigen.key.age;
    owner = config.services.firefly-iii-data-importer.user;
    inherit (config.services.firefly-iii-data-importer) group;
  };

  services.postgresql = {
    ensureDatabases = [config.services.firefly-iii.user];
    ensureUsers = [
      {
        name = config.services.firefly-iii.user;
        ensureDBOwnership = true;
      }
    ];
  };

  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
    virtualHosts = {
      ":21312" = {
        extraConfig = ''
          root * "${config.services.firefly-iii.package}/public"

          php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket} {
            env modHeadersAvailable true
            env HTTPS true
            env SERVER_PROTOCOL https
          }
          file_server
        '';
      };
      ":25322" = {
        extraConfig = ''
          root * "${config.services.firefly-iii-data-importer.package}/public"

          php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii-data-importer.socket} {
            env modHeadersAvailable true
            env HTTPS true
            env SERVER_PROTOCOL https
          }
          file_server
        '';
      };
    };
  };

  services.firefly-iii = {
    enable = true;
    group = "caddy";
    settings = {
      DB_CONNECTION = "pgsql";
      APP_KEY_FILE = config.age.secrets."firefly-iii.key".path;
    };
    virtualHost = "money.eclipse.sefa.cloud";
  };

  services.firefly-iii-data-importer = {
    enable = true;
    group = "caddy";
    virtualHost = "money-import.eclipse.sefa.cloud";
    settings = {
      FIREFLY_III_URL = "https://money.eclipse.sefa.cloud";
      FIREFLY_III_ACCESS_TOKEN_FILE = config.age.secrets."firefly-iii-token".path;
      NORDIGEN_ID = "9b087504-c529-4e30-acd4-617e425aa859";
      NORDIGEN_KEY_FILE = config.age.secrets."firefly-iii-nordigen.key".path;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.firefly-iii = {
      entryPoints = ["localsecure"];
      service = "firefly-iii";
      rule = "Host(`money.eclipse.sefa.cloud`)";
    };
    services.firefly-iii.loadBalancer.servers = [{url = "http://localhost:21312";}];
    routers.firefly-iii-data-importer = {
      entryPoints = ["localsecure"];
      service = "firefly-iii-data-importer";
      rule = "Host(`money-import.eclipse.sefa.cloud`)";
    };
    services.firefly-iii-data-importer.loadBalancer.servers = [{url = "http://localhost:25322";}];
  };
}
