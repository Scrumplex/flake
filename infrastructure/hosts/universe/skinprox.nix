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

  services.nginx = {
    upstreams.skinprox.servers."localhost:${toString config.services.skinprox.listenPort}" = {};
    virtualHosts."skins.scrumplex.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://skinprox";
        extraConfig = ''
          add_header Access-Control-Allow-Origin *;
        '';
      };
    };
  };
}
