{config, ...}: {
  services.tandoor-recipes = {
    enable = true;
    port = 22001;
    extraConfig = {
      # TODO: use something better
      GUNICORN_MEDIA = true;
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
