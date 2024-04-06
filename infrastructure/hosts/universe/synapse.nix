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

  virtualisation.oci-containers.containers."draupnir" = {
    image = config.virtualisation.oci-containers.externalImages.images."draupnir".ref;
    volumes = [
      "/srv/draupnir:/data"
    ];
  };

  services.nginx.virtualHosts = {
    "duckhub.io" = {
      root = pkgs.fetchFromGitea {
        domain = "codeberg.org";
        owner = "Scrumplex";
        repo = "duckhub-static";
        rev = "f5fa8a372d12f6dfeeb925cbf4fa87967b4808cc";
        hash = "sha256-+snAi7qmP2N/Svhosi84A4s8GAi4fz4coW7JsWY/NAE=";
      };
      locations = {
        "/.well-known/matrix".extraConfig = ''
          default_type "application/json";
          add_header Access-Control-Allow-Origin *;
        '';
        "~* \\.html$".extraConfig = ''
          expires max;
        '';
        "~* \\.(css|js|svg|png|eot|woff2?)$".extraConfig = ''
          expires max;
        '';
      };
    };
    "quack.duckhub.io" = {
      root = pkgs.element-web;
      locations."= /config.json".alias = pkgs.writeText "element-web-config.json" (builtins.toJSON {
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
      routers = {
        synapse = {
          entryPoints = ["websecure" "synapsesecure"];
          service = "synapse";
          rule = "Host(`duckhub.io`, `quack.duckhub.io`) && PathPrefix(`/_matrix`)";
        };
        duckhub = {
          entryPoints = ["websecure"];
          service = "nginx";
          rule = "Host(`duckhub.io`)";
        };
        element = {
          entryPoints = ["websecure"];
          service = "nginx";
          rule = "Host(`quack.duckhub.io`)";
        };
      };

      services.synapse.loadBalancer.servers = [{url = "http://localhost:8008";}];
    };
  };
}
