{
  config,
  lib,
  ...
}: {
  age.secrets."searx.env".file = ../../secrets/universe/searx.env.age;

  services.searx = {
    enable = true;

    environmentFile = config.age.secrets."searx.env".path;
    settings.server.secret_key = "@SEARX_SECRET_KEY@";
  };
  services.nginx = {
    upstreams.searx.servers."localhost:8888" = {};
    virtualHosts."searx.scrumplex.net" = lib.mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/".proxyPass = "http://searx";
      }
    ];
  };
}
