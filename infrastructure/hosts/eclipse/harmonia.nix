{config, ...}: {
  age.secrets."harmonia-signing.key".file = ../../secrets/eclipse/harmonia-signing.key.age;
  services.harmonia = {
    enable = true;
    signKeyPath = config.age.secrets."harmonia-signing.key".path;
    settings.bind = "127.0.0.1:5050";
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.harmonia = {
      entryPoints = ["websecure"];
      service = "harmonia";
      middlewares = "harmonia-compress";
      rule = "Host(`cache.sefa.cloud`)";
    };
    services.harmonia.loadBalancer.servers = [{url = "http://${config.services.harmonia.settings.bind}";}];
    middlewares.harmonia-compress.compress = {};
  };
}
