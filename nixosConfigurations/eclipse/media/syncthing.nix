{
  fpConfig,
  config,
  lib,
  ...
}: {
  age.secrets."syncthing-key.pem" = {
    file = ../../../secrets/eclipse/syncthing-key.pem.age;
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };
  age.secrets."syncthing-cert.pem" = {
    file = ../../../secrets/eclipse/syncthing-cert.pem.age;
    owner = config.services.syncthing.user;
    group = config.services.syncthing.group;
  };

  services.syncthing = {
    enable = true;
    user = "media";
    group = "media";

    key = config.age.secrets."syncthing-key.pem".path;
    cert = config.age.secrets."syncthing-cert.pem".path;
    openDefaultPorts = true;

    settings = {
      devices = lib.getAttrs ["andromeda" "antares" "borealis" "dyson" "galileo"] fpConfig.flake.meta.syncthingDevices;

      folders = {
        "Music" = {
          enable = true;
          id = "txukz-pi5xa";
          type = "receiveonly";
          path = "/media/jellyfin/music_sefa";
          devices = ["andromeda" "borealis" "dyson" "galileo"];
        };
        "VRC" = {
          enable = true;
          id = "byk2l-xga7c";
          type = "receiveonly";
          path = "/media/syncthing/VRC";
          devices = ["andromeda" "antares"];
        };
        "VRCX Data" = {
          enable = true;
          id = "tfbtt-sgbyw";
          type = "receiveonly";
          path = "/media/syncthing/VRCX Data";
          devices = ["andromeda" "antares"];
        };
      };
    };
  };

  systemd.services."syncthing".unitConfig.RequiresMountsFor = ["/media"];

  services.traefik.dynamic.files."syncthing".settings.http = {
    routers.syncthing = {
      entryPoints = ["websecure"];
      middlewares = ["internal-only"];
      service = "syncthing";
      rule = "Host(`syncthing.eclipse.sefa.cloud`)";
    };
    services.syncthing.loadBalancer = {
      servers = [{url = "http://localhost:8384";}];
      passHostHeader = false;
    };
  };
}
