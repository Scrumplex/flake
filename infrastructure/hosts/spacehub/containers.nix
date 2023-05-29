{
  config,
  lib,
  ...
}: let
  inherit (builtins) elem hasAttr;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.modules) mkIf mkMerge;

  commonEnv = {
    TZ = "Europe/Berlin";
    PUID = "1337";
    GUID = "1337";
  };

  dataPath = "/srv/spacehub";

  mkContainer = args @ {
    name,
    externalImage ? name,
    environment ? {},
    ...
  }: {
    ${name} = mkMerge [
      {
        service.environment = commonEnv // environment;
      }
      (mkIf (! hasAttr "image" args) {
        service.image = config.virtualisation.oci-containers.externalImages.images.${externalImage}.ref;
      })
      (filterAttrs (n: _: ! elem n ["name" "externalImage" "environment"]) args)
    ];
  };
in {
  virtualisation.arion = {
    backend = "docker";
    projects = {
      scrumplex-website.settings.services = mkMerge [
        (mkContainer rec {
          name = "scrumplex-website";
          service.labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${name}.rule" = "Host(`scrumplex.net`)";
            "traefik.http.routers.${name}.entrypoints" = "websecure";
          };
        })

        (mkContainer {
          name = "tor";
          environment = {
            SERVICE1_TOR_SERVICE_HOSTS = "80:scrumplex-website:80";
            SERVICE1_TOR_SERVICE_VERSION = "3";
          };
          service.env_file = [
            config.age.secrets."tor-service.env".path
          ];
        })
      ];
      scrumplex-x.settings.services = mkContainer rec {
        name = "scrumplex-x";
        environment.PRNT_PATH = "/data";
        service.env_file = [
          config.age.secrets."scrumplex-x-service.env".path
        ];
        service.volumes = [
          "${dataPath}/x-data:${environment.PRNT_PATH}"
        ];
        service.labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${name}.rule" = "Host(`scrumplex.rocks`) || Host(`x.scrumplex.rocks`) || Host(`x.scrumplex.net`)";
          "traefik.http.routers.${name}.entrypoints" = "websecure";
          "traefik.http.routers.${name}.middlewares" = "redirect_x,${name}-cors";
          "traefik.http.middlewares.redirect_x.redirectRegex.regex" = "^https?:\\/\\/x\\.scrumplex\\.(rocks|net)(.*)";
          "traefik.http.middlewares.redirect_x.redirectRegex.replacement" = "https://scrumplex.rocks$${2}";
          "traefik.http.middlewares.redirect_x.redirectRegex.permanent" = "true";
          "traefik.http.middlewares.${name}-cors.headers.accesscontrolallowmethods" = "GET,OPTIONS";
          "traefik.http.middlewares.${name}-cors.headers.accesscontrolalloworiginlist" = "*";
          "traefik.http.middlewares.${name}-cors.headers.accesscontrolmaxage" = "300";
          "traefik.http.middlewares.${name}-cors.headers.addvaryheader" = "true";
        };
      };
      voip.settings = {
        # We use host networking for these containers!
        enableDefaultNetwork = false;
        services = mkMerge [
          (mkContainer {
            name = "ts3";
            service.volumes = [
              "${dataPath}/ts3-data:/var/ts3server"
            ];
            service.network_mode = "host";
          })
          (mkContainer {
            name = "murmur";
            environment.MUMBLE_CUSTOM_CONFIG_FILE = "/data/murmur.ini";
            service.volumes = [
              "${dataPath}/murmur-data:/data"
            ];
            service.network_mode = "host";
          })
        ];
      };
      hedgedoc.settings.services = mkMerge [
        (mkContainer rec {
          name = "hedgedoc";
          environment = {
            CMD_DB_HOST = "postgres";
            CMD_DOMAIN = "doc.scrumplex.net";
            CMD_PROTOCOL_USESSL = "true";
            CMD_HSTS_ENABLE = "false";
            CMD_ALLOW_EMAIL_REGISTER = "false";
          };
          service.depends_on = ["postgres"];
          service.env_file = [
            config.age.secrets."hedgedoc-service.env".path
          ];
          service.volumes = [
            "${dataPath}/hedgedoc-data:/hedgedoc/public/uploads"
          ];
          service.labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${name}.rule" = "Host(`doc.scrumplex.net`)";
            "traefik.http.routers.${name}.entrypoints" = "websecure";
          };
        })

        (mkContainer {
          name = "postgres";
          externalImage = "postgres13";
          service.env_file = [
            config.age.secrets."hedgedoc-service.env".path
          ];
          service.volumes = [
            "${dataPath}/hedgedoc-postgres-data:/var/lib/postgresql/data"
          ];
        })
      ];
      skinprox.settings.services = mkContainer rec {
        name = "skinprox";
        environment = {
          SKINPROX_URL = "https://skins.scrumplex.net";
          SKINPROX_PROVIDERS = "https://skins.ddnet.org/skin/community/ https://skins.tee.world/ https://api.skins.tw/api/resolve/skins/";
        };
        service.labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${name}.rule" = "Host(`skins.scrumplex.net`)";
          "traefik.http.routers.${name}.entrypoints" = "websecure";
        };
      };
    };
  };
}
