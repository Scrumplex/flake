{config, ...}: {
  age.secrets."vaultwarden.env" = {
    file = ../../secrets/eclipse/vaultwarden.env.age;
    owner = config.users.users.vaultwarden.name;
    group = config.users.groups.vaultwarden.name;
  };
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vault.sefa.cloud";
      SIGNUPS_ALLOWED = false;

      ROCKET_PORT = 8222;

      WEBSOCKET_ENABLED = true;
      WEBSOCKET_PORT = 3012;

      # key, id and endpoints set in .env
      PUSH_ENABLED = true;

      SSO_ENABLED = true;
      SSO_AUTHORITY = "https://auth.scrumplex.net";
      SSO_SCOPES = "openid email profile";
      SSO_CLIENT_ID = "175d84f2-5a98-4560-97e1-68c9ed70034d";
    };
    environmentFile = config.age.secrets."vaultwarden.env".path;

    backupDir = "/var/backup/vaultwarden";
  };

  services.traefik.dynamic.files."vaultwarden".settings.http = {
    routers = {
      vaultwarden = {
        entryPoints = ["websecure"];
        service = "vaultwarden";
        rule = "Host(`vault.sefa.cloud`)";
      };
      vaultwardenWS = {
        entryPoints = ["websecure"];
        service = "vaultwardenWS";
        rule = "Host(`vault.sefa.cloud`) && Path(`/notifications/hub/`)";
      };
    };
    services = {
      vaultwarden.loadBalancer.servers = [{url = "http://localhost:${toString config.services.vaultwarden.config.ROCKET_PORT}";}];
      vaultwardenWS.loadBalancer.servers = [{url = "http://localhost:${toString config.services.vaultwarden.config.WEBSOCKET_PORT}";}];
    };
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.vaultwarden.backupDir} 0770 ${config.users.users.vaultwarden.name} ${config.users.users.vaultwarden.name}"
  ];

  services.borgbackup.jobs.borgbase.paths = [config.services.vaultwarden.backupDir];
}
