{config, ...}: {
  age.secrets."slskd-creds.env" = {
    file = ../../../secrets/eclipse/slskd-creds.env.age;
    owner = "media";
    group = "media";
  };
  services.slskd = {
    enable = true;
    user = "media";
    group = "media";
    domain = null;
    environmentFile = config.age.secrets."slskd-creds.env".path;
    openFirewall = true;
    settings = {
      shares = {
        directories = ["/media/jellyfin/music_sefa"];
        filters = ["musiclibrary.db"];
      };
      directories = {
        downloads = "/media/slskd/downloads";
        incomplete = "/media/slskd/incomplete";
      };
    };
  };

  systemd.services."slskd".unitConfig.RequiresMountsFor = "/media";

  services.traefik.dynamicConfigOptions.http = {
    routers.slskd = {
      entryPoints = ["localsecure"];
      service = "slskd";
      rule = "Host(`slskd.eclipse.sefa.cloud`)";
    };
    services.slskd.loadBalancer.servers = [{url = "http://localhost:${toString config.services.slskd.settings.web.port}";}];
  };

  systemd.tmpfiles.settings."10-slskd" = {
    "/media/slskd/downloads"."d" = {
      user = "media";
      group = "media";
    };
    "/media/slskd/incomplete"."d" = {
      user = "media";
      group = "media";
    };
  };
}
