{
  config,
  pkgs,
  ...
}: {
  age.secrets."home-assistant-secrets.yaml" = {
    file = ./secrets.yaml.age;
    owner = "hass";
    group = "hass";
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="2ed25a95ac3aef11a9c02c1455516304", SYMLINK+="ttyUSB-SONOFF-ZigBee"
  '';

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"

      # My components
      "androidtv_remote"
      "backup"
      "bluetooth"
      "cast" # Google Cast
      "co2signal" # Electricity Maps
      "denonavr"
      "dwd_weather_warnings"
      "esphome"
      "holiday"
      "immich"
      "local_todo"
      "meater"
      "met"
      "mobile_app"
      "nina"
      "proximity"
      "radio_browser"
      "shopping_list"
      "smartthings"
      "steam_online"
      "sun"
      "tuya"
      "waqi" # World Air Quality Index
      "zha"

      # for xiaomi_home
      "ffmpeg"
      "zeroconf"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      adaptive_lighting
      moonraker
      # powercalc
      waste_collection_schedule
      xiaomi_home
    ];
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      # catppuccin-theme
      universal-remote-card
    ];
    config = {
      homeassistant = {
        name = "Beehive";
        latitude = "!secret latitude";
        longitude = "!secret longitude";
        elevation = "!secret elevation";
        unit_system = "metric";
        time_zone = config.time.timeZone;
      };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
      };
      default_config = {};

      "automation ui" = "!include automations.yaml";
      "scene ui" = "!include scenes.yaml";
      "script ui" = "!include scripts.yaml";
    };
  };

  systemd.tmpfiles.settings."10-hass"."/var/lib/hass/secrets.yaml".L.argument = config.age.secrets."home-assistant-secrets.yaml".path;

  services.traefik.dynamicConfigOptions.http = {
    routers.home-assistant = {
      entryPoints = ["websecure"];
      service = "home-assistant";
      rule = "Host(`hass.sefa.cloud`)";
    };
    services.home-assistant.loadBalancer.servers = [{url = with config.services.home-assistant.config.http; "http://localhost:${toString server_port}";}];
  };
}
