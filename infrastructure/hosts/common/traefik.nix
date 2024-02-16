{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib) types;

  cfg = config.common.traefik;
in {
  options.common.traefik = {
    primaryEntryPoint = mkOption {
      type = with types; str;
      default = "websecure";
    };

    primaryCertResolver = mkOption {
      type = with types; str;
      default = "letsencrypt";
    };
  };

  config = {
    networking.firewall.allowedTCPPorts = [80 443];

    systemd.services.traefik.serviceConfig = {
      EnvironmentFile = [config.age.secrets."hetzner.key".path];
    };

    services.traefik = {
      enable = true;
      group =
        if config.virtualisation.docker.enable
        then "docker"
        else "podman";

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
  };
}
