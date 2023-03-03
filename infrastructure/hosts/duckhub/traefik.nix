{config, ...}: {
  networking.firewall.allowedTCPPorts = [8448];
  services.traefik.staticConfigOptions.entryPoints.synapsesecure =
    config.services.traefik.staticConfigOptions.entryPoints.websecure
    // {
      address = ":8448";
    };
}
