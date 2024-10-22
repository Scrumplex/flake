{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
    autoPrune.enable = true;
  };

  virtualisation.oci-containers.backend = "podman";

  services.traefik.group = "podman";

  networking.firewall.trustedInterfaces = ["podman+"];
}
