{
  flake.modules.nixos."ext-media" = {
    services.syncthing = {
      enable = true;
      user = "media";
      group = "media";
      openDefaultPorts = true;
    };

    services.traefik.dynamic.files."syncthing".settings.http.services.syncthing.loadBalancer = {
      servers = [{url = "http://localhost:8384";}];
      passHostHeader = false;
    };
  };
}
