{
  flake.modules.nixos.ext-docker = {
    virtualisation.docker = {
      enable = true;
      liveRestore = false;
      autoPrune = {
        enable = true;
        flags = ["--all"];
      };
    };

    virtualisation.oci-containers.backend = "docker";

    services.traefik = {
      supplementaryGroups = ["docker"];
      static.settings.providers.docker.exposedByDefault = false;
    };
  };
}
