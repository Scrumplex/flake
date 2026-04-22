{
  config,
  lib,
  ...
}: {
  flake.modules.nixos."machine-universe" = {
    imports = [config.flake.modules.nixos."ext-traefik"];

    services.traefik.static.settings.entryPoints = {
      web.address = lib.mkForce ":80";
      websecure.address = lib.mkForce ":443";
    };

    services.traefik.dynamic.files."nginx".settings.http.services.nginx.loadBalancer.servers = [{url = "http://127.0.0.1:8993";}];
  };
}
