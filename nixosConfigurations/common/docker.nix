{
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };

  virtualisation.oci-containers.backend = "docker";

  services.traefik.group = "docker";
}
