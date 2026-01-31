{
  flake.modules.nixos."machine-galileo" = {config, ...}: {
    services.home-assistant.config.http = {
      use_x_forwarded_for = true;
      trusted_proxies = [
        "127.0.0.1"
        "::1"
      ];
    };

    services.traefik.dynamicConfigOptions.http = {
      routers.home-assistant = {
        entryPoints = ["websecure"];
        service = "home-assistant";
        rule = "Host(`hass.sefa.cloud`)";
      };
      services.home-assistant.loadBalancer.servers = [{url = with config.services.home-assistant.config.http; "http://localhost:${toString server_port}";}];
    };
  };
}
