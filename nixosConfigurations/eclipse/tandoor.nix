{
  config,
  inputs,
  pkgs,
  ...
}: let
  user = "tandoor_recipes";
in {
  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "Postgres must be enabled for Paperless to function.";
    }
  ];

  services.postgresql = {
    ensureDatabases = [user];
    ensureUsers = [
      {
        name = user;
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
      POSTGRES_USER = user;
      POSTGRES_DB = user;
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
