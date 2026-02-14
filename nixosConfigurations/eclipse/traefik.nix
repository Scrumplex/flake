{config, ...}: {
  age.secrets."hetzner-api-token.env".file = ./hetzner-api-token.env.age;

  networking.firewall.allowedTCPPorts = [80 443 8443];

  services.traefik = {
    enable = true;

    static.settings = {
      api.insecure = true;
      accessLog = {};
      providers.docker.exposedByDefault = false;
      entryPoints = {
        web = {
          address = ":80";
          http = {
            redirections.entryPoint = {
              to = "localsecure";
              scheme = "https";
              permanent = true;
            };
            middlewares = "security@file";
          };
        };
        "localsecure" = {
          address = ":443";
          http = {
            tls.certResolver = "letsencrypt";
            middlewares = "security@file";
          };
        };
        "websecure" = {
          address = ":8443";
          http = config.services.traefik.static.settings.entryPoints.localsecure.http;
        };
      };
      certificatesResolvers.letsencrypt.acme = {
        email = "contact@scrumplex.net";
        storage = "/var/lib/traefik/acme-le-dns.json";
        keyType = "EC384";
        dnsChallenge.provider = "hetzner";
      };
    };

    dynamic.dir = "/var/lib/traefik/dynamic";

    dynamic.files."common".settings.http.middlewares.security.headers = {
      stsSeconds = 31536000;
      stsIncludeSubdomains = true;
      stsPreload = true;
    };
  };

  services.traefik.dynamic.files."nextcloud".settings.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      service = "nextcloud";
      rule = "Host(`box.sefa.cloud`)";
    };
    services.nextcloud.loadBalancer.servers = [{url = "http://localhost:7701";}];
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-api-token.env".path];
}
