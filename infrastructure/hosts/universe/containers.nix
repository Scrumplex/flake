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
  age.secrets."scrumplex-x-service.env".file = ../../secrets/universe/scrumplex-x-service.env.age;

  virtualisation.docker.enable = false;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };
  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  networking.firewall.trustedInterfaces = ["podman+"];

  virtualisation.arion = {
    backend = "podman-socket";
    projects = {
      scrumplex-x.settings.services = mkContainer rec {
        name = "scrumplex-x";
        environment.PRNT_PATH = "/data";
        service.env_file = [
          config.age.secrets."scrumplex-x-service.env".path
        ];
        service.volumes = [
          "${dataPath}/x-data:${environment.PRNT_PATH}"
        ];
        service.ports = [
          "3001:8080"
        ];
      };
    };
  };

  services.nginx = {
    upstreams.scrumplex-x.servers."localhost:3001" = {};
    virtualHosts = {
      "scrumplex.rocks" = lib.mkMerge [
        config.common.nginx.vHost
        config.common.nginx.sslVHost
        {
          locations."/".proxyPass = "http://scrumplex-x";
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
          globalRedirect = "scrumplex.rocks";
        }
      ];
    };
  };

  systemd.services."arion-refraction".serviceConfig = {
    Restart = "always";
    RestartSec = 2;
  };
}
