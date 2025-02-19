{config, ...}: {
  age.secrets."hetzner-traefik.env".file = ../../secrets/eclipse/hetzner-traefik.env.age;

  common.traefik = {
    primaryEntryPoint = "localsecure";
    primaryCertResolver = "local";
  };

  networking.firewall.allowedTCPPorts = [8443];

  services.traefik.staticConfigOptions = {
    entryPoints.websecure = {
      address = ":8443";
      http = config.services.traefik.staticConfigOptions.entryPoints.localsecure.http // {tls.certResolver = "letsencrypt";};
    };
    certificatesResolvers.local.acme = {
      email = "contact@scrumplex.net";
      storage = "/var/lib/traefik/acme-local.json";
      keyType = "EC384";
      httpChallenge.entryPoint = "web";
      caServer = "https://10.10.10.12:9443/acme/acme/directory";
    };
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
