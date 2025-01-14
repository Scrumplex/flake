{config, ...}: {
  age.secrets."hetzner-traefik.env".file = ../../secrets/cosmos/hetzner-traefik.env.age;

  common.traefik = {
    primaryEntryPoint = "websecure";
    primaryCertResolver = "letsencrypt";
  };

  services.traefik.staticConfigOptions.certificatesResolvers.local.acme = {
    email = "contact@scrumplex.net";
    storage = "/var/lib/traefik/acme-local.json";
    keyType = "EC384";
    httpChallenge.entryPoint = "web";
    caServer = "https://tls.eclipse.sefa.cloud/acme/acme/directory";
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-traefik.env".path];
}
