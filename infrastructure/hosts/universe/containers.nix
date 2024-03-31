{
  config,
  lib,
  pkgs,
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

  dataPath = "/srv/containers";

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
  age.secrets."refraction-service.env".file = ../../secrets/universe/refraction-service.env.age;
  age.secrets."scrumplex-x-service.env".file = ../../secrets/universe/scrumplex-x-service.env.age;
  age.secrets."tor-service.env".file = ../../secrets/universe/tor-service.env.age;

  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  networking.firewall.trustedInterfaces = ["podman+"];

  virtualisation.arion = {
    backend = "podman-socket";
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

        (mkContainer rec {
          name = "ovenmediaengine";
          environment = {
            OME_SRT_PROV_PORT = "1935";
            OME_DISTRIBUTION = "live.scrumplex.net";
            OME_APPLICATION = "scrumplex";
          };
          service.ports = [
            "3333:3333" # WebRTC Signaling
            "3478:3478" # WebRTC Relay
            "1935:1935" # RTMP Ingest
            "10000-10005:10000-10005/udp" # WebRTC ICE
          ];
          service.volumes = [
            "${dataPath}/ovenmediaengine-Server.xml:/opt/ovenmediaengine/bin/origin_conf/Server.xml"
          ];
          service.labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${name}.rule" = "Host(`live.scrumplex.net`)";
            "traefik.http.routers.${name}.entrypoints" = "websecure";
            "traefik.http.services.${name}.loadbalancer.server.port" = "3333";
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
      honeylinks.settings.services = mkContainer rec {
        name = "honeylinks";
        service.labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${name}.rule" = "Host(`honeyarcus.art`)";
          "traefik.http.routers.${name}.entrypoints" = "websecure";
        };
      };
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
      refraction.settings.services = mkMerge [
        (mkContainer {
          name = "redis";
          service.volumes = [
            "${dataPath}/refraction-redis-data:/data"
          ];
        })
        (mkContainer {
          name = "refraction";
          environment = {
            DISCORD_APP = "1034470391252521051";
            SAY_LOGS_CHANNEL = "1112764181012283542";
            REDIS_URL = "redis://redis:6379";
          };
          service.env_file = [
            config.age.secrets."refraction-service.env".path
          ];
          service.depends_on = [
            "redis"
          ];
        })
      ];
    };
  };

  systemd.services."arion-refraction".serviceConfig = {
    Restart = "always";
    RestartSec = 2;
  };
}
