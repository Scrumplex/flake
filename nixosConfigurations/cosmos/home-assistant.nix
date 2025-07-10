{config, ...}: {
  hardware.bluetooth.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", ATTRS{serial}=="2ed25a95ac3aef11a9c02c1455516304", SYMLINK+="ttyUSB-SONOFF-ZigBee"
  '';

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
      "--device=/dev/ttyUSB1"
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
}
