{
  config,
  lib,
  pkgs,
  ...
}: let
  settingsFormat = pkgs.formats.yaml {};
  confWithoutNullValues = (
    lib.filterAttrsRecursive (
      _: value: (builtins.tryEval value).success && value != null
    )
    config.services.slskd.settings
  );

  configurationYaml = settingsFormat.generate "slskd.yml" confWithoutNullValues;
in {
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
      web.authentication.api_keys."lidarr" = {
        key = "\${SLSKD_API_KEY_LIDARR}";
        cidr = "0.0.0.0/0,::/0";
      };
    };
  };

  systemd.services."slskd" = {
    preStart = ''
      ${pkgs.envsubst}/bin/envsubst \
        -i "${configurationYaml}" \
        -o "$RUNTIME_DIRECTORY/slskd.yml"
    '';
    serviceConfig = {
      ExecStart = lib.mkForce "${config.services.slskd.package}/bin/slskd --app-dir \${STATE_DIRECTORY} --config \${RUNTIME_DIRECTORY}/slskd.yml";
      RuntimeDirectory = "slskd";
    };
  };

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
