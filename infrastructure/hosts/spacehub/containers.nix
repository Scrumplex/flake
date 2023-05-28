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
      (mkIf (hasAttr externalImage config.virtualisation.oci-containers.externalImages.images) {
        service.image = config.virtualisation.oci-containers.externalImages.images.${externalImage}.ref;
      })
      (filterAttrs (n: _: ! elem n ["name" "externalImage" "environment"]) args)
    ];
  };
in {
  virtualisation.arion = {
    backend = "docker";
    projects = {
      scrumplex-website.settings = {
        services = mkMerge [
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
      };
      scrumplex-x.settings = {
        services = mkContainer rec {
          name = "scrumplex-x";
          environment.PRNT_PATH = "/data";
          service.env_file = [
            config.age.secrets."scrumplex-x-service.env".path
          ];
          service.volumes = [
            "/srv/spacehub/x-data:${environment.PRNT_PATH}"
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
      };
    };
  };
}
