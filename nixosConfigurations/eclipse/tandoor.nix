{
  config,
  inputs,
  pkgs,
  ...
}: {
  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "Postgres must be enabled for Paperless to function.";
    }
  ];

  services.postgresql = {
    ensureDatabases = [config.services.tandoor-recipes.user];
    ensureUsers = [
      {
        name = config.services.tandoor-recipes.user;
        ensureDBOwnership = true;
      }
    ];
  };

  services.tandoor-recipes = {
    enable = true;
    package = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.tandoor-recipes;
    port = 22001;
    extraConfig = {
      # TODO: use something better
      GUNICORN_MEDIA = true;

      DB_ENGINE = "django.db.backends.postgresql";
      POSTGRES_HOST = "/run/postgresql";
      POSTGRES_USER = config.services.tandoor-recipes.user;
      POSTGRES_DB = config.services.tandoor-recipes.user;
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.tandoor = {
      entryPoints = ["websecure"];
      service = "tandoor";
      rule = "Host(`cook.sefa.cloud`)";
    };
    services.tandoor.loadBalancer.servers = [{url = "http://localhost:${toString config.services.tandoor-recipes.port}";}];
  };
}
