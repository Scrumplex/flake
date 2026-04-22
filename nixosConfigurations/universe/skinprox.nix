{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.skinprox.nixosModules.skinprox];

  services.skinprox = {
    enable = true;
    package = inputs.skinprox.packages.${pkgs.stdenv.hostPlatform.system}.skinprox;
    publicUrl = "https://skins.scrumplex.net";
    providers = [
      "https://scrumplex.rocks/skin/"
      "https://skins.ddnet.org/skin/community/"
      "https://skins.tee.world/"
    ];
  };

  services.traefik.dynamic.files."skinprox".settings.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      middlewares = ["allow-cors"];
      service = "skinprox";
      rule = "Host(`skins.scrumplex.net`)";
    };
    services.skinprox.loadBalancer.servers = [{url = "http://localhost:${toString config.services.skinprox.listenPort}";}];
  };
}
