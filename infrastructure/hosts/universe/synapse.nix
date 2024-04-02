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
        {
          port = 9008;
          tls = false;
          type = "http";
          resources = [
            {
              compress = false;
              names = ["metrics"];
            }
          ];
        }
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

      enable_metrics = true;

      signing_key_path = config.age.secrets."synapse.signing.key".path;

      server_notices = {
        system_mxid_localpart = "notices";
        system_mxid_display_name = "Server Notices";
      };
    };
    extraConfigFiles = [config.age.secrets."synapse-secrets.yaml".path];
  };

  virtualisation.oci-containers.containers = {
    element-web = {
      image = config.virtualisation.oci-containers.externalImages.images."element-web".ref;
      volumes = let
        element-web-config = pkgs.writeText "element-web-config.json" (builtins.toJSON {
          default_server_name = "duckhub.io";
          default_server_config = {
            "m.homeserver".base_url = "https://quack.duckhub.io";
            "m.identity_server".base_url = "https://vector.im";
          };
          default_country_code = "DE";
          room_directory.servers = ["matrix.org" "gitter.im" "libera.chat"];
          default_device_display_name = "Duckhub Web";
          brand = "Duckhub";
          terms_and_conditions_links = [
            {
              text = "Privacy Policy";
              url = "https://scrumplex.net/#privacy";
            }
          ];
        });
      in [
        "${element-web-config}:/app/config.json:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.element.rule" = "Host(`quack.duckhub.io`)";
        "traefik.http.routers.element.entrypoints" = "websecure";
      };
    };

    duckhub-static = {
      image = config.virtualisation.oci-containers.externalImages.images."duckhub-static".ref;
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.duckhub-static.rule" = "Host(`duckhub.io`)";
        "traefik.http.routers.duckhub-static.entrypoints" = "websecure";
      };
    };

    draupnir = {
      image = config.virtualisation.oci-containers.externalImages.images."draupnir".ref;
      volumes = [
        "/srv/draupnir:/data"
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [8448];

  services.prometheus.scrapeConfigs = [
    {
      job_name = "synapse";
      metrics_path = "/_synapse/metrics";
      static_configs = [
        {
          targets = ["localhost:9008"];
        }
      ];
    }
  ];

  services.traefik = {
    staticConfigOptions.entryPoints.synapsesecure = {
      address = ":8448";
      http = config.services.traefik.staticConfigOptions.entryPoints.websecure.http;
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
