{config, ...}: {
  age.secrets."otel-hass-token.env".file = ../../secrets/cosmos/otel-hass-token.env.age;

  hardware.bluetooth.enable = true;
  hardware.raspberry-pi."4".bluetooth.enable = true;

  virtualisation.oci-containers.containers.home-assistant = {
    image = config.virtualisation.oci-containers.externalImages.images."home-assistant".ref;
    environment = {
      TZ = config.time.timeZone;
      PUID = "1337";
      PGID = "1337";
    };
    volumes = [
      "/srv/home-assistant:/config"
      "/etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro"
      "/dev/serial:/dev/serial"
      "/run/dbus:/run/dbus:ro"
    ];
    extraOptions = [
      "--device=/dev/ttyUSB0"
      "--network=host"
      "--privileged"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.hass = {
      entryPoints = ["websecure"];
      service = "hass";
      rule = "Host(`hass.sefa.cloud`)";
    };
    services.hass.loadBalancer.servers = [{url = "http://localhost:8123";}];
  };

  systemd.services.opentelemetry-collector.serviceConfig.EnvironmentFile = [
    config.age.secrets."otel-hass-token.env".path
  ];

  services.opentelemetry-collector.settings.receivers.prometheus.config.scrape_configs = [
    {
      job_name = "hass";
      scrape_interval = "60s";

      bearer_token = "\${env:PROM_HASS_BEARER}";

      metrics_path = "/api/prometheus";
      scheme = "https";
      static_configs = [
        {
          targets = ["hass.sefa.cloud"];
        }
      ];
    }
  ];
}
