let
  ageSettings = {
    owner = "matrix-synapse";
    group = "matrix-synapse";
  };
in
  {
    config,
    lib,
    pkgs,
    ...
  }: {
    age.secrets."synapse.signing.key" =
      {
        file = ../../../secrets/universe/synapse.signing.key.age;
      }
      // ageSettings;
    age.secrets."synapse-secrets.yaml" =
      {
        file = ../../../secrets/universe/synapse-secrets.yaml.age;
      }
      // ageSettings;
    age.secrets."synapse-client-secret" =
      {
        file = ./synapse-client-secret.age;
      }
      // ageSettings;

    services.postgresql.initScript = ''
      CREATE ROLE "matrix-synapse";
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';

    alloc.tcpPorts.blocks.synapse-metrics.length = 1;

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
            port = config.alloc.tcpPorts.blocks.synapse-metrics.start;
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

        oidc_providers = [
          {
            idp_id = "scrumplex-auth";
            idp_name = "Scrumplex Auth";
            issuer = "https://auth.scrumplex.net";
            client_id = "20e27243-a945-4dcb-a004-d8628ee92d12";
            client_secret_path = config.age.secrets."synapse-client-secret".path;
            scopes = ["openid" "profile" "email"];
            user_mapping_provider.config = {
              localpart_template = "{{ user.preferred_username }}";
              display_name_template = "{{ user.name }}";
              email_template = "{{ user.email }}";
              confirm_localpart = true;
            };
          }
        ];

        admin_contact = "mailto:contact@scrumplex.net";

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

      log = {
        loggers = {
          "synapse.access.http.8008".level = "WARNING";
          "synapse.federation.transport.server.federation".level = "WARNING";
          "synapse.federation.sender.transaction_manager".level = "WARNING";
        };
      };
    };

    services.nginx = {
      virtualHosts = {
        "duckhub.io" = lib.mkMerge [
          config.common.nginx.vHost
          {
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
          }
        ];
        "quack.duckhub.io" = lib.mkMerge [
          config.common.nginx.vHost
          {
            root = pkgs.element-web;
            locations = {
              "= /config.json".alias = pkgs.writeText "element-web-config.json" (builtins.toJSON {
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
          }
        ];
      };
    };

    services.traefik.static.settings.entryPoints.synapsesecure = {
      address = ":8448";
      http = {
        tls.certResolver = "letsencrypt";
        middlewares = "security@file";
      };
      http3 = {};
    };

    services.traefik.dynamic.files."synapse".settings.http = {
      routers = {
        synapse-federation = {
          entryPoints = ["websecure" "synapsesecure"];
          service = "synapse";
          rule = "(Host(`quack.duckhub.io`) || Host(`duckhub.io`)) && (PathPrefix(`/_matrix/`) || PathPrefix(`/_synapse/client`))";
        };
        duckhub-homepage = {
          entryPoints = ["websecure"];
          service = "nginx";
          rule = "Host(`duckhub.io`)";
        };
        element-web = {
          entryPoints = ["websecure"];
          service = "nginx";
          rule = "Host(`quack.duckhub.io`)";
        };
      };
      services.synapse.loadBalancer.servers = [{url = "http://localhost:8008";}];
    };

    networking.firewall.allowedTCPPorts = [8448];

    # Because Synapse exposes its metrics in a different path, we need a custom config here
    environment.etc."alloy/synapse.alloy".text = ''
      prometheus.scrape "synapse" {
        targets = [
          {"__address__" = "localhost:${toString config.alloc.tcpPorts.blocks.synapse-metrics.start}"},
        ]

        metrics_path = "/_synapse/metrics"

        forward_to = [otelcol.receiver.prometheus.default.receiver]
      }
    '';
  }
