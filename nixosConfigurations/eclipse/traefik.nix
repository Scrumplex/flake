{config, ...}: {
  age.secrets."hetzner-traefik.env".file = ../../secrets/eclipse/hetzner-traefik.env.age;

  common.traefik = {
    primaryEntryPoint = "localsecure";
    primaryCertResolver = "letsencrypt";
  };

  networking.firewall.allowedTCPPorts = [8443];

  services.traefik.staticConfigOptions.entryPoints.websecure = {
    address = ":8443";
    http = config.services.traefik.staticConfigOptions.entryPoints.localsecure.http // {tls.certResolver = "letsencrypt";};
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.skinprox = {
      entryPoints = ["websecure"];
      service = "nextcloud";
      rule = "Host(`box.sefa.cloud`)";
    };
    services.nextcloud.loadBalancer.servers = [{url = "http://localhost:7701";}];
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-traefik.env".path];
}
