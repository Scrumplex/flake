{
  flake.modules.nixos."ext-traefik" = {config, ...}: {
    age.secrets."hetzner-api-token.env".file = ./hetzner-api-token.env.age;

    networking.firewall.allowedTCPPorts = [80 443];

    services.traefik = {
      enable = true;

      staticConfigOptions = {
        api.insecure = true;
        accessLog = {};
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
          storage = "/var/lib/traefik/acme-le-dns.json";
          keyType = "EC384";
          dnsChallenge.provider = "hetzner";
        };
      };

      dynamicConfigOptions.http.middlewares = {
        "security".headers = {
          stsSeconds = 31536000;
          stsIncludeSubdomains = true;
          stsPreload = true;
        };
        "internal-only".ipAllowList.sourceRange = [
          "10.0.0.0/8"
          "172.16.0.0/12"
          "192.168.0.0/16"
          "fc00::/8"
          "fd00::/8"
        ];
      };
    };

    systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-api-token.env".path];
  };
}
