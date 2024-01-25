{config, ...}: {
  services.skinprox = {
    enable = true;
    publicUrl = "https://skins.scrumplex.net";
    providers = [
      #"https://scrumplex.rocks/skin/"
      "https://skins.ddnet.org/skin/community/"
      "https://skins.tee.world/"
      "https://assets.ddstats.org/skins/"
      "https://api.skins.tw/api/resolve/skins/"
      "https://raw.githubusercontent.com/TeeworldsDB/skins/master/06/"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      service = "skinprox";
      rule = "Host(`skins.scrumplex.net`)";
    };
    services.skinprox.loadBalancer.servers = [{url = "http://localhost:${toString config.services.skinprox.listenPort}";}];
  };
}
