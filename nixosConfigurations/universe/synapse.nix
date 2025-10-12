{
  config,
  lib,
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

  services.postgresql.initScript = ''
    CREATE ROLE "matrix-synapse";
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

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
      };
    };
  };

  virtualisation.oci-containers.containers."draupnir" = {
    image = config.virtualisation.oci-containers.externalImages.images."draupnir".ref;
    volumes = [
      "/srv/draupnir:/data"
    ];
  };

  services.nginx = {
    upstreams.synapse.servers."localhost:8008" = {};
    virtualHosts = {
      "duckhub.io" = lib.mkMerge [
        config.common.nginx.vHost
        config.common.nginx.sslVHost
        {
          extraConfig = ''
            listen 0.0.0.0:8448 ssl default_server;
            listen [::0]:8448 ssl default_server;
          '';

          root = pkgs.fetchFromGitea {
            domain = "codeberg.org";
            owner = "Scrumplex";
            repo = "duckhub-static";
            rev = "f5fa8a372d12f6dfeeb925cbf4fa87967b4808cc";
            hash = "sha256-+snAi7qmP2N/Svhosi84A4s8GAi4fz4coW7JsWY/NAE=";
          };
          locations = {
            "~ ^(/_matrix|/_synapse/client)" = {
              proxyPass = "http://synapse";
              extraConfig = ''
                client_max_body_size 50M;
                proxy_http_version 1.1;
              '';
            };
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
        config.common.nginx.sslVHost
        {
          root = pkgs.element-web;
          locations = {
            "~ ^(/_matrix|/_synapse/client)" = {
              proxyPass = "http://synapse";
              extraConfig = ''
                client_max_body_size 50M;
                proxy_http_version 1.1;
              '';
            };
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

  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8043"
  ];

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
}
