{
  flake.modules.nixos."ext-podman" = {
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
    };

    virtualisation.oci-containers.backend = "podman";

    services.traefik = {
      supplementaryGroups = ["podman"];
      static.settings.providers.docker = {
        exposedByDefault = false;
        endpoint = "unix:///run/podman/podman.sock";
      };
    };
  };
}
