let
  fqdn = "grafana.scrumplex.net";
in {
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.grafana.length = 1;

    age.secrets."grafana-smtp-password" = {
      file = ./smtp-password.age;
      owner = config.systemd.services.grafana.serviceConfig.User;
    };
    age.secrets."grafana-secret-key" = {
      file = ./secret-key.age;
      owner = config.systemd.services.grafana.serviceConfig.User;
    };
    age.secrets."grafana-client-secret" = {
      file = ./client-secret.age;
      owner = config.systemd.services.grafana.serviceConfig.User;
    };

    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "::1";
          http_port = config.alloc.tcpPorts.blocks.grafana.start;
          root_url = "https://${fqdn}/";
        };
        security.secret_key = "$__file{${config.age.secrets."grafana-secret-key".path}}";
        smtp = {
          enabled = true;
          host = "smtp-relay.brevo.com:587";
          user = "contact@scrumplex.net";
          password = "$__file{${config.age.secrets."grafana-smtp-password".path}}";
          from_address = "notify@sefa.cloud";
        };
        "auth.generic_oauth" = {
          enabled = true;
          client_id = "85434528-414e-420e-86b2-b1f32e4f4a71";
          client_secret = "$__file{${config.age.secrets."grafana-client-secret".path}}";
          auth_url = "https://auth.scrumplex.net/authorize";
          token_url = "https://auth.scrumplex.net/api/oidc/token";
          api_url = "https://auth.scrumplex.net/api/oidc/userinfo";
          scopes = "openid profile email groups";
          auto_login = true;
          login_attribute_path = "sub";
          name_attribute_path = "name";
          email_attribute_path = "email";
          role_attribute_path = "contains(groups[*], 'grafana_admin') && 'Admin' || 'Viewer'";
          use_pkce = true;
        };
      };

      provision.enable = true;
    };

    services.traefik.dynamic.files."lgtm".settings.http = {
      routers.grafana = {
        entryPoints = ["websecure"];
        service = "grafana";
        rule = "Host(`${fqdn}`)";
      };
      services.grafana.loadBalancer.servers = [{url = "http://[::1]:${toString config.alloc.tcpPorts.blocks.grafana.start}";}];
    };
  };
}
