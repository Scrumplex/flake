{
  config,
  lib,
  pkgs,
  ...
}: let
  fqdn = "mail.scrumplex.rocks";
in {
  age.secrets."stalwart.env".file = ../../secrets/universe/stalwart.env.age;

  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    settings = {
      lookup.default.hostname = fqdn;

      server.listener = {
        smtp = {
          bind = ["[::]:25"];
          protocol = "smtp";
        };
        submissions = {
          bind = ["[::]:465"];
          protocol = "smtp";
          tls.implicit = true;
        };
        imaps = {
          bind = "[::]:993";
          protocol = "imap";
          tls.implicit = true;
        };
        server.listener.management = {
          bind = ["127.0.0.1:3010"];
          protocol = "http";
        };
      };

      certificate.default = {
        cert = "%{file:/run/credentials/stalwart-mail.service/cert.pem}%";
        private-key = "%{file:/run/credentials/stalwart-mail.service/key.pem}%";
      };

      directory.default = {
        type = "internal";
        store = "db";
      };
      storage.directory = "default";

      authentication.fallback-admin = {
        user = "admin";
        secret = "%{env:ADMIN_SECRET}%";
      };
    };
  };

  systemd.services.stalwart-mail.serviceConfig = {
    EnvironmentFile = [config.age.secrets."stalwart.env".path];
    LoadCredential = [
      "cert.pem:${config.security.acme.certs.${fqdn}.directory}/cert.pem"
      "key.pem:${config.security.acme.certs.${fqdn}.directory}/key.pem"
    ];
  };

  services.nginx = {
    upstreams."stalwart-mail".servers."localhost:3010" = {};
    virtualHosts.${fqdn} = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://stalwart-mail";
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [25 465 993];
}
