{
  inputs,
  pkgs,
  ...
}: {
  services.influxdb2 = {
    enable = true;
    package = inputs.nixpkgs-prev.legacyPackages.${pkgs.system}.influxdb2;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.influx = {
      entryPoints = ["localsecure"];
      service = "influx";
      rule = "Host(`influx.eclipse.lan`)";
    };
    services.influx.loadBalancer.servers = [{url = "http://localhost:8086";}];
  };
}
