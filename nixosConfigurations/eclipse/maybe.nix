{config, ...}: let
  railsEnv = {
  };
in {
  virtualisation.oci-containers.containers = {
    maybe-web = {
      image = config.virtualisation.oci-containers.externalImages.images."maybe".ref;
      environment = {
        TZ = config.time.timeZone;
      };
      volumes = [
        "/srv/maybe:/rails/storage"
      ];
      extraOptions = [
        "--device=/dev/ttyUSB0"
        "--device=/dev/ttyUSB1"
        "--network=host"
        "--privileged"
      ];
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.hass = {
      entryPoints = ["websecure"];
      service = "hass";
      rule = "Host(`hass.sefa.cloud`)";
    };
    services.hass.loadBalancer.servers = [{url = "http://localhost:8123";}];
  };
}
