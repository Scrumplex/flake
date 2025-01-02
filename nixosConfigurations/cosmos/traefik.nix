{...}: {
  common.traefik = {
    primaryEntryPoint = "localsecure";
    primaryCertResolver = "local";
  };

  services.traefik.staticConfigOptions.certificatesResolvers.local.acme = {
    email = "contact@scrumplex.net";
    storage = "/var/lib/traefik/acme-local.json";
    keyType = "EC384";
    httpChallenge.entryPoint = "web";
    caServer = "https://tls.eclipse.sefa.cloud/acme/acme/directory";
  };
}
