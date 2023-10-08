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

      ROCKET_ADDRESS = "0.0.0.0";
      WEBSOCKET_ENABLED = true;
      WEBSOCKET_ADDRESS = "0.0.0.0";
      WEBSOCKET_PORT = 3012;
    };
    environmentFile = config.age.secrets."vaultwarden.env".path;

    backupDir = "/var/backup/vaultwarden";
  };

  systemd.tmpfiles.rules = [
    "d ${config.services.vaultwarden.backupDir} 0770 ${config.users.users.vaultwarden.name} ${config.users.users.vaultwarden.name}"
  ];

  services.borgbackup.jobs.borgbase.paths = [config.services.vaultwarden.backupDir];
}
