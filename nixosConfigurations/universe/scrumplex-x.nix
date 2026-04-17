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
        config.common.nginx.sslVHost
        {
          root = dataPath;
          extraConfig = ''
            add_header Access-Control-Allow-Origin *;
          '';
        }
      ];
      "x.scrumplex.rocks" = lib.mkMerge [
        config.common.nginx.vHost
        config.common.nginx.sslVHost
        {
          serverAliases = ["x.scrumplex.net"];
          globalRedirect = fqdn;
        }
      ];
    };
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
