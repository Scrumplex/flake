{config, ...}: {
  networking.firewall.allowedTCPPorts = [80 443];

  systemd.services.traefik.serviceConfig = {
    EnvironmentFile = config.age.secrets."hetzner.key".path;
  };

  services.traefik = {
    enable = true;
    group = "docker";

    staticConfigOptions = {
      api.insecure = true;
      accessLog = {};
      providers.docker.exposedByDefault = false;
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

    dynamicConfigOptions.http.middlewares.security.headers = {
      stsSeconds = 31536000;
      stsIncludeSubdomains = true;
      stsPreload = true;
    };
  };
}
