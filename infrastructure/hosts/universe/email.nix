{
  config,
  lib,
  pkgs,
  ...
}: let
  fqdn = "mail.scrumplex.rocks";
  credDir = "/run/credentials/stalwart-mail.service";

  mkIfS = cond: value: {
    "if" = cond;
    "then" = value;
  };

  mkElseS = value: {
    "else" = value;
  };

  mkIfLocal = mkIfS "remote_ip == '127.0.0.1' || remote_ip == '::1'";
in {
  age.secrets."stalwart.env".file = ../../secrets/universe/stalwart.env.age;

  services.stalwart-mail = {
    enable = true;
    package = pkgs.stalwart-mail;
    settings = {
      config.local-keys = ["session.*"];
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
        web = {
          bind = ["127.0.0.1:3010"];
          protocol = "http";
        };
      };

      session.auth.require = [
        (mkIfLocal false) # Allow unauthenticated SMTP for localhost
        (mkElseS true)
      ];
      session.rcpt.relay = [
        (mkIfS "!is_empty(authenticated_as)" true) # Allow relay for authenticated SMTP
        (mkIfLocal true) # Allow relay for localhost
        (mkElseS false)
      ];

      certificate.default = {
        cert = "%{file:${credDir}/cert.pem}%";
        private-key = "%{file:${credDir}/key.pem}%";
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

      tracer.stdout = {
        enable = true;
        type = "stdout";
        level = "info";
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
        serverAliases = [
          "autoconfig.scrumplex.rocks"
          "autodiscover.scrumplex.rocks"
        ];
        locations."/" = {
          proxyPass = "http://stalwart-mail";
          proxyWebsockets = true;
        };
      }
    ];
  };

  networking.firewall.allowedTCPPorts = [25 465 993];
}
