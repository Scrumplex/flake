{
  config,
  lib,
  pkgs,
  ...
}: let
  fqdn = "scrumplex.rocks";
  dataPath = "/var/lib/screenshots";
in {
  age.secrets."scrumplex-x.htaccess" = {
    file = ../../secrets/universe/scrumplex-x.htaccess.age;
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };

  services.nginx = {
    additionalModules = with pkgs.nginxModules; [
      dav
    ];

    upstreams.scrumplex-x.servers."localhost:3001" = {};

    virtualHosts = {
      ${fqdn} = lib.mkMerge [
        config.common.nginx.vHost
        config.common.nginx.sslVHost
        {
          root = dataPath;
          locations."/".extraConfig = ''
            limit_except GET {
              auth_basic "scrumplex-x";
              auth_basic_user_file ${config.age.secrets."scrumplex-x.htaccess".path};
            }
          '';
          extraConfig = ''
            dav_methods PUT;
            create_full_put_path on;

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

  systemd.services."nginx".serviceConfig.ReadWritePaths = [dataPath];

  systemd.tmpfiles.settings = {
    "10-scrumplex-x".${dataPath}.d = {
      mode = "0755";
      user = config.services.nginx.user;
      group = config.services.nginx.group;
    };
  };
}
