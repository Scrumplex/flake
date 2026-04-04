{
  config,
  lib,
  ...
}: let
  fConfig = config;
in {
  flake.meta.syncthingDevices."galileo".id = "JAEGE6Y-FQLD6KU-V3FHUXV-AVHF5GA-IPSUW7E-AQ6X5HA-7VREEVL-YENQRQR";

  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets."syncthing-key.pem" = {
      file = ./key.pem.age;
      owner = config.services.syncthing.user;
      group = config.services.syncthing.group;
    };
    age.secrets."syncthing-cert.pem" = {
      file = ./cert.pem.age;
      owner = config.services.syncthing.user;
      group = config.services.syncthing.group;
    };

    services.syncthing = {
      key = config.age.secrets."syncthing-key.pem".path;
      cert = config.age.secrets."syncthing-cert.pem".path;

      settings = {
        devices = lib.getAttrs ["andromeda" "borealis" "dyson" "eclipse"] fConfig.flake.meta.syncthingDevices;
        folders."Music" = {
          enable = true;
          id = "txukz-pi5xa";
          type = "receiveonly";
          path = "${config.services.syncthing.dataDir}/music_sefa";
          devices = ["andromeda" "borealis" "dyson" "eclipse"];
        };
      };
    };

    services.traefik.dynamic.files."syncthing".settings.http.routers.syncthing = {
      entryPoints = ["websecure"];
      middlewares = ["internal-only"];
      service = "syncthing";
      rule = "Host(`syncthing.galileo.sefa.cloud`)";
    };
  };
}
