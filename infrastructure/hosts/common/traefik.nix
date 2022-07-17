{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets."hetzner.key".path;
  };

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api = {
        insecure = true;
      };
      accessLog = { };
      providers.docker = {
        exposedByDefault = false;
      };
      entryPoints = {
        web = {
          address = ":80";
          http = {
            redirections.entryPoint = {
              to = "websecure";
              scheme = "https";
              permanent = true;
            };
            middlewares = "security@file";
          };
        };
        websecure = {
          address = ":443";
          http = {
            tls.certResolver = "letsencrypt";
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

    dynamicConfigOptions = {
      http.middlewares.security.headers = {
        stsSeconds = 31536000;
        stsIncludeSubdomains = true;
        stsPreload = true;
      };
      tls.options.default = {
        minVersion = "VersionTLS12";
        cipherSuites = [
          # TLS 1.3
          "TLS_AES_256_GCM_SHA384"
          "TLS_CHACHA20_POLY1305_SHA256"
          #"TLS_SHA384_SHA384"  # not support yet

          # TLS 1.2
          "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
        ];
        curvePreferences = [
          "CurveP521"
          "CurveP384"
        ];
        sniStrict = true;
      };
    };
  };
}

