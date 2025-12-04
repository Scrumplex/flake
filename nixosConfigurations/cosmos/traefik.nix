{config, ...}: {
  age.secrets."hetzner-api-token.env".file = ./hetzner-api-token.env.age;

  common.traefik = {
    primaryEntryPoint = "websecure";
    primaryCertResolver = "letsencrypt";
  };

  systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-api-token.env".path];
}
