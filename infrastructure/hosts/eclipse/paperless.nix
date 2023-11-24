{config, ...}: {
  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "Postgres must be enabled for Paperless to function.";
    }
  ];

  services.postgresql = {
    # TODO: This needs manual changes. The database owner needs to be `paperless`.
    # Run `echo "ALTER DATABASE paperless OWNER TO paperless" | sudo -u postgres psql`
    ensureDatabases = [config.services.paperless.user];
    ensureUsers = [
      {
        name = config.services.paperless.user;
        ensurePermissions = {
          "DATABASE ${config.services.paperless.user}" = "ALL PRIVILEGES";
        };
        ensureDBOwnership = true;
      }
    ];
  };

  services.paperless = {
    enable = true;

    address = "0.0.0.0"; # not allowed in firewall!

    passwordFile = config.age.secrets.paperless-password.path;

    extraConfig = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_TIME_ZONE = config.time.timeZone;
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_ADMIN_USER = "Scrumplex";
      PAPERLESS_URL = "https://paperless.eclipse.lan";
    };
  };
}
