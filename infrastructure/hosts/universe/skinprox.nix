{
  config,
  inputs,
  pkgs,
  ...
}: {
  services.skinprox = {
    enable = true;
    package = inputs.skinprox.packages.${pkgs.system}.skinprox;
    publicUrl = "https://skins.scrumplex.net";
    providers = [
      #"https://scrumplex.rocks/skin/"
      "https://skins.ddnet.org/skin/community/"
      "https://skins.tee.world/"
      "https://assets.ddstats.org/skins/"
      "https://api.skins.tw/api/resolve/skins/"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      service = "skinprox";
      rule = "Host(`skins.scrumplex.net`)";
      middlewares = ["skinprox"];
    };
    middlewares.skinprox.headers = {
      accessControlAllowMethods = ["GET"];
      accessControlAllowOriginList = ["*"];
      accessControlMaxAge = 100;
    };
    services.skinprox.loadBalancer.servers = [{url = "http://localhost:${toString config.services.skinprox.listenPort}";}];
  };
}
