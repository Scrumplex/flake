{
  config,
  lib,
  pkgs,
  ...
}: let
  fqdn = "scrumplex.rocks";
  dataPath = "/var/lib/screenshots";
in {
  services.nginx = {
    upstreams.scrumplex-x.servers."localhost:3001" = {};

    virtualHosts = {
      ${fqdn} = lib.mkMerge [
        config.common.nginx.vHost
        {
          root = dataPath;
          extraConfig = ''
            add_header Access-Control-Allow-Origin *;
          '';
        }
      ];
      "x.scrumplex.rocks" = lib.mkMerge [
        config.common.nginx.vHost
        {
          serverAliases = ["x.scrumplex.net"];
          globalRedirect = fqdn;
        }
      ];
    };
  };

  services.traefik.dynamic.files."scrumplex-x".settings.http.routers.scrumplex-x = {
    entryPoints = ["websecure"];
    middlewares = ["allow-cors"];
    service = "nginx";
    rule = "Host(`scrumplex.rocks`) || Host(`x.scrumplex.rocks`)";
  };

  systemd.services."nginx".serviceConfig.ReadOnlyPaths = [dataPath];

  systemd.tmpfiles.settings = {
    "10-scrumplex-x".${dataPath}.d = {
      mode = "0755";
      user = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
}
