{config, ...}: {
  age.secrets."home-assistant-secrets.yaml" = {
    file = ../../secrets/eclipse/home-assistant-secrets.yaml.age;
    owner = "hass";
    group = "hass";
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "default_config"
      "google_translate"
      "met"
      "zha"
    ];
    config = {
      homeassistant = {
        name = "Haus";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = config.time.timeZone;
      };
      http = {
        server_host = "127.0.0.1";
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
        ];
      };
    };
  };

  systemd.tmpfiles.settings."10-hass"."/var/lib/hass/secrets.yaml".L.argument = config.age.secrets."home-assistant-secrets.yaml".path;

  services.traefik.dynamicConfigOptions.http = {
    routers.home-assistant = {
      entryPoints = ["websecure"];
      service = "home-assistant";
      rule = "Host(`smart.sefa.cloud`)";
    };
    services.home-assistant.loadBalancer.servers = [{url = with config.services.home-assistant.config.http; "http://${server_host}:${toString server_port}";}];
  };
}
