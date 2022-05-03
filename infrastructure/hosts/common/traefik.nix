{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
          "TLS_AES_256_GCM_SHA384"
          "TLS_CHACHA20_POLY1305_SHA256"
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

