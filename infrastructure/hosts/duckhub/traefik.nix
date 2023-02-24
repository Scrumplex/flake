{ ... }:

{
  networking.firewall.allowedTCPPorts = [ 8448 ];
  services.traefik.staticConfigOptions.entryPoints.synapsesecure = {
    address = ":8448";
    http = {
      tls.options = "hardened@file";
      tls.certResolver = "letsencrypt";
      middlewares = "security@file";
    };
  };
}
