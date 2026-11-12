let
  fqdn = "pds.scrumplex.net";
in {
  flake.modules.nixos."machine-universe" = {config, ...}: {
    alloc.tcpPorts.blocks.pds.length = 1;

    age.secrets."pds.env".file = ./pds.env.age;

    services.bluesky-pds = {
      enable = true;

      pdsadmin.enable = true;

      environmentFiles = [
        config.age.secrets."pds.env".path
      ];

      settings = {
        PDS_HOSTNAME = fqdn;
        PDS_SERVICE_HANDLE_DOMAINS = ".duckhub.io";
        PDS_PORT = config.alloc.tcpPorts.blocks.pds.start;
      };
    };

    services.traefik.dynamic.files."pds".settings.http = {
      routers.pds = {
        entryPoints = ["websecure"];
        service = "pds";
        rule = "Host(`${fqdn}`) || Host(`*.duckhub.io`)";
        priority = 1;
      };
      services.pds.loadBalancer.servers = [{url = "http://[::1]:${toString config.services.bluesky-pds.settings.PDS_PORT}";}];
    };
  };
}
