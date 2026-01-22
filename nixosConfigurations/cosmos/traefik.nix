{config, ...}: {
  age.secrets."hetzner-api-token.env".file = ./hetzner-api-token.env.age;

  common.traefik = {
    primaryEntryPoint = "websecure";
    primaryCertResolver = "letsencrypt";
  };

  services.traefik.dynamicConfigOptions.http.middlewares."internal-only".ipAllowList.sourceRange = [
    "10.0.0.0/8"
    "172.16.0.0/12"
    "192.168.0.0/16"
    "fc00::/8"
    "fd00::/8"
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = [config.age.secrets."hetzner-api-token.env".path];
}
