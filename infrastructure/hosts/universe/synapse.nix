{
  config,
  pkgs,
  ...
}: {
  age.secrets."synapse.signing.key" = {
    file = ../../secrets/universe/synapse.signing.key.age;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };
  age.secrets."synapse-secrets.yaml" = {
    file = ../../secrets/universe/synapse-secrets.yaml.age;
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };

  services.postgresql = {
    # TODO refactor?
    initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse";
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';
  };

  services.matrix-synapse = {
    enable = true;

    settings = {
      server_name = "duckhub.io";

      web_client_location = "https://quack.duckhub.io/";
      public_baseurl = "https://quack.duckhub.io/";
      default_identity_server = "https://vector.im";

      presence.enabled = true;

      allow_public_rooms_without_auth = true;
      allow_public_rooms_over_federation = true;

      listeners = [
        {
          port = 8008;
          tls = false;
          type = "http";
          x_forwarded = true;

          resources = [
            {
              compress = false;
              names = ["client" "federation"];
            }
          ];
        }
        #{
        #  port = 9000;
        #  type = "metrics";
        #}
      ];

      admin_contact = "mailto:contact@scrumplex.net";

      limit_remote_rooms = {
        enabled = true;
        complexity = 2.0;
      };

      url_preview_enabled = true;
      url_preview_url_blacklist = [
        {username = "*";}
      ];
      max_spider_size = "16M";

      auto_join_rooms = [
        "#announcements:duckhub.io"
        "#general:duckhub.io"
      ];

      #enable_metrics = true;

      signing_key_path = config.age.secrets."synapse.signing.key".path;

      server_notices = {
        system_mxid_localpart = "notices";
        system_mxid_display_name = "Server Notices";
      };
    };
    extraConfigFiles = [config.age.secrets."synapse-secrets.yaml".path];
  };

  networking.firewall.allowedTCPPorts = [8448];

  services.traefik = {
    staticConfigOptions.entryPoints.synapsesecure =
      config.services.traefik.staticConfigOptions.entryPoints.websecure
      // {
        address = ":8448";
      };
    dynamicConfigOptions.http = {
      routers.synapse = {
        entryPoints = ["websecure" "synapsesecure"];
        service = "synapse";
        rule = "Host(`duckhub.io`, `quack.duckhub.io`) && PathPrefix(`/_matrix`)";
      };
      services.synapse.loadBalancer.servers = [{url = "http://localhost:8008";}];
    };
  };
}
