{config, ...}: {
  services.skinprox = {
    enable = true;
    publicUrl = "https://skins.scrumplex.net";
    providers = [
      "https://scrumplex.rocks/skin/"
      "https://skins.ddnet.org/skin/community/"
      "https://skins.tee.world/"
      "https://api.skins.tw/api/resolve/skins/"
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
