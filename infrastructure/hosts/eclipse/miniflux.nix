{config, ...}: let
  fqdn = "miniflux.eclipse.lan";
in {
  age.secrets."miniflux.env".file = ../../secrets/eclipse/miniflux.env.age;

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets."miniflux.env".path;
    config = {
      BASE_URL = "https://${fqdn}";
      LISTEN_ADDR = "localhost:8069";
    };
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.miniflux = {
      entryPoints = ["localsecure"];
      service = "miniflux";
      rule = "Host(`${fqdn}`)";
    };
    services.miniflux.loadBalancer.servers = [{url = "http://${config.services.miniflux.config.LISTEN_ADDR}";}];
  };
}
