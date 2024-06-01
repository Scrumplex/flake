{config, ...}: {
  age.secrets."harmonia-signing.key".file = ../../secrets/eclipse/harmonia-signing.key.age;
  services.harmonia = {
    enable = true;
    signKeyPath = config.age.secrets."harmonia-signing.key".path;
    settings.bind = "127.0.0.1:5050";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.harmonia = {
      entryPoints = ["localsecure"];
      service = "harmonia";
      middlewares = "harmonia-compress";
      rule = "Host(`cache.eclipse.lan`)";
    };
    services.harmonia.loadBalancer.servers = [{url = "http://${config.services.harmonia.settings.bind}";}];
    middlewares.harmonia-compress.compress = {};
  };
}
