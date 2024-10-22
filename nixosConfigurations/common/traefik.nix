{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge mkOption types;

  cfg = config.common.traefik;
in {
  options.common.traefik = {
    enableMetrics = mkEnableOption "traefik prometheus metrics";

    primaryEntryPoint = mkOption {
      type = with types; str;
      default = "websecure";
    };

    primaryCertResolver = mkOption {
      type = with types; str;
      default = "letsencrypt";
    };
  };

  config = mkMerge [
    {
      networking.firewall.allowedTCPPorts = [80 443];

      systemd.services.traefik.serviceConfig = {
        EnvironmentFile = [config.age.secrets."hetzner.key".path];
      };

      services.traefik = {
        enable = true;

        staticConfigOptions = {
          api.insecure = true;
          accessLog = {};
          providers.docker.exposedByDefault = false;
          entryPoints = {
            web = {
              address = ":80";
              http = {
                redirections.entryPoint = {
                  to = cfg.primaryEntryPoint;
                  scheme = "https";
                  permanent = true;
                };
                middlewares = "security@file";
              };
            };
            ${cfg.primaryEntryPoint} = {
              address = ":443";
              http = {
                tls.certResolver = cfg.primaryCertResolver;
                middlewares = "security@file";
              };
            };
          };
          certificatesResolvers.letsencrypt.acme = {
            email = "contact@scrumplex.net";
            storage = "/var/lib/traefik/acme-le.json";
            keyType = "EC384";
            httpChallenge.entryPoint = "web";
          };
          certificatesResolvers.letsencryptDNS.acme = {
            email = "contact@scrumplex.net";
            storage = "/var/lib/traefik/acme-le-dns.json";
            keyType = "EC384";
            dnsChallenge.provider = "hetzner";
          };
        };

        dynamicConfigOptions.http.middlewares.security.headers = {
          stsSeconds = 31536000;
          stsIncludeSubdomains = true;
          stsPreload = true;
        };
      };
    }
    (mkIf cfg.enableMetrics {
      services.traefik.staticConfigOptions.metrics.prometheus = {};
      services.prometheus.scrapeConfigs = [
        {
          job_name = "traefik";
          static_configs = [
            {
              targets = ["localhost:8080"];
            }
          ];
        }
      ];
    })
  ];
}
