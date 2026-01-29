let
  mkSecret = file: {
    inherit file;
    owner = "archisteamfarm";
    group = "archisteamfarm";
  };
in {
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    age.secrets = {
      "asf-ipc-passwd" = mkSecret ./asf-ipc-passwd.age;
      "asf-bot1.json" = mkSecret ./asf-bot1.json.age;
      "asf-bot2.json" = mkSecret ./asf-bot2.json.age;
    };

    services.archisteamfarm = {
      enable = true;
      web-ui.enable = true;
      ipcPasswordFile = config.age.secrets."asf-ipc-passwd".path;
      settings = {
        SteamOwnerID = 76561198122396352; # Scrumplex
        SteamTokenDumperPluginEnabled = true;
      };
    };

    systemd.tmpfiles.settings."50-asf" = {
      "${config.services.archisteamfarm.dataDir}/config/bot1.json"."L+".argument = config.age.secrets."asf-bot1.json".path;
      "${config.services.archisteamfarm.dataDir}/config/bot2.json"."L+".argument = config.age.secrets."asf-bot2.json".path;
    };

    services.traefik.dynamicConfigOptions.http = {
      routers.asf = {
        entryPoints = ["websecure"];
        middlewares = ["internal-only"];
        service = "asf";
        rule = "Host(`asf.galileo.sefa.cloud`)";
      };
      services.asf.loadBalancer.servers = [{url = "http://localhost:1242";}];
    };
  };
}
