{config, ...}: {
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
      devices = {
        "andromeda".id = "PUP74AL-VXGLRML-MLMUZIJ-5SZCUCK-A3H2VKD-HNB5X7Z-HHDI244-O7KU5AL";
        "antares".id = "MOD53BR-TS455TP-KWYY4VD-RQ7JLZM-NSURG2I-GLAFRFQ-K4XIWQ4-7BMPBQK";
        "dyson".id = "KW6OFUM-DN2HFJT-GDQPMCP-Q6LQWAV-2OZP7VP-CZJSZH7-HZX2JFB-GN4IBQ2";
        "void".id = "ROC6PRH-RGV3UZK-YZADBBJ-WKEQPDT-N6QWDRR-QGCFEXT-OSLP5GH-7FUD5AJ";
      };

      folders = {
        "Music" = {
          enable = true;
          id = "txukz-pi5xa";
          type = "receiveonly";
          path = "/media/jellyfin/music_sefa";
          devices = ["andromeda" "dyson" "void"];
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

  services.traefik.dynamicConfigOptions.http = {
    routers.syncthing = {
      entryPoints = ["localsecure"];
      service = "syncthing";
      rule = "Host(`syncthing.eclipse.sefa.cloud`)";
    };
    services.syncthing.loadBalancer = {
      servers = [{url = "http://localhost:8384";}];
      passHostHeader = false;
    };
  };
}
