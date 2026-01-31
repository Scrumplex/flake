{lib, ...}: {
  flake.modules.nixos."machine-galileo" = {
    config,
    pkgs,
    ...
  }: {
    age.secrets."home-assistant-secrets.yaml" = {
      file = ./secrets.yaml.age;
      owner = "hass";
      group = "hass";
    };

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
        default_config = {};

        "automation ui" = "!include automations.yaml";
        "scene ui" = "!include scenes.yaml";
        "script ui" = "!include scripts.yaml";
      };
    };

    systemd.tmpfiles.settings."10-hass"."/var/lib/hass/secrets.yaml".L.argument = config.age.secrets."home-assistant-secrets.yaml".path;

    nixpkgs.config.allowUnfreePredicate = pkg: (builtins.elem (lib.getName pkg) [
      "XiaoMi/xiaomi_home"
    ]);
  };
}
