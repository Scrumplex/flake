{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedTCPPorts = [ 8448 ];
  services.traefik.staticConfigOptions.entryPoints.synapsesecure = {
    address = ":8448";
    http = {
      tls.options = "default@file";
      tls.certResolver = "letsencrypt";
      middlewares = "security@file";
    };
  };
}
