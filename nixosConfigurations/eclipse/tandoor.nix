{config, ...}: {
  assertions = [
    {
      assertion = config.services.postgresql.enable;
      message = "Postgres must be enabled for Paperless to function.";
    }
  ];

  age.secrets."tandoor-recipes.env".file = ../../secrets/eclipse/tandoor-recipes.env.age;

  services.tandoor-recipes = {
    enable = true;
    port = 22001;
    database.createLocally = true;
    extraConfig = {
      # TODO: use something better
      GUNICORN_MEDIA = true;
    };
  };

  systemd.services."tandoor-recipes".serviceConfig.EnvironmentFile = [
    config.age.secrets."tandoor-recipes.env".path
  ];

  services.traefik.dynamicConfigOptions.http = {
    routers.tandoor = {
      entryPoints = ["websecure"];
      service = "tandoor";
      rule = "Host(`cook.sefa.cloud`)";
    };
    services.tandoor.loadBalancer.servers = [{url = "http://localhost:${toString config.services.tandoor-recipes.port}";}];
  };
}
