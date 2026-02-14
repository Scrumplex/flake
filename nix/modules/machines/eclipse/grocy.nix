let
  port = 8765;
in {
  flake.modules.nixos."machine-eclipse" = {config, ...}: {
    services.grocy = {
      enable = true;
      hostName = "grocy.sefa.cloud";
      nginx.enableSSL = false;
      settings = {
        currency = "EUR";
        culture = "de";
        calendar.firstDayOfWeek = 1;
      };
    };

    services.nginx.virtualHosts."${config.services.grocy.hostName}".listen = [
      {
        addr = "127.0.0.1";
        inherit port;
      }
    ];

    services.traefik.dynamic.files."grocy".settings.http = {
      routers.grocy = {
        entryPoints = ["websecure"];
        service = "grocy";
        rule = "Host(`grocy.sefa.cloud`)";
      };
      services.grocy.loadBalancer.servers = [{url = "http://localhost:${toString port}";}];
    };
  };
}
