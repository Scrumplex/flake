{config, ...}: {
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
    ];
    extraOptions = [
      "--device=/dev/ttyUSB0"
      "--network=host"
      "--privileged"
    ];
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.hass = {
      entryPoints = ["localsecure"];
      service = "hass";
      rule = "Host(`hass.cosmos.lan`)";
    };
    services.hass.loadBalancer.servers = [{url = "http://localhost:8123";}];
  };
}
