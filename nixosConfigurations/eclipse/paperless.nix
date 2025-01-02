{
  config,
  pkgs,
  ...
}: {
  age.secrets.paperless-password.file = ../../secrets/eclipse/paperless-password.age;

  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "Postgres must be enabled for Paperless to function.";
    }
  ];

  services.postgresql = {
    ensureDatabases = [config.services.paperless.user];
    ensureUsers = [
      {
        name = config.services.paperless.user;
        ensureDBOwnership = true;
      }
    ];
  };

  services.paperless = {
    enable = true;

    package = pkgs.paperless-ngx.overrideAttrs (prevAttrs: {
      disabledTests =
        prevAttrs.disabledTests
        or []
        ++ [
          "test_error_skip_rule"
        ];
    });

    passwordFile = config.age.secrets.paperless-password.path;
    settings = {
      PAPERLESS_DBHOST = "/run/postgresql";
      PAPERLESS_TIME_ZONE = config.time.timeZone;
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_ADMIN_USER = "Scrumplex";
      PAPERLESS_URL = "https://paperless.eclipse.sefa.cloud";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.paperless = {
      entryPoints = ["localsecure"];
      service = "paperless";
      rule = "Host(`paperless.eclipse.sefa.cloud`)";
    };
    services.paperless.loadBalancer.servers = [{url = "http://localhost:${toString config.services.paperless.port}";}];
  };
}
