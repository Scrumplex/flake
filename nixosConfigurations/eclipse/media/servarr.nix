{
  config,
  lib,
  pkgs,
  ...
}: {
  services.radarr = {
    enable = true;
    user = "media";
    group = "media";
  };
  services.sonarr = {
    enable = true;
    user = "media";
    group = "media";
  };
  services.lidarr = {
    enable = false;
    package = pkgs.lidarr.overrideAttrs (let
      version = "2.12.0.4634";
      branch = "plugins";
    in {
      pname = "lidarr${lib.optionalString (branch != "master") "-${branch}"}";
      inherit version;
      src = pkgs.fetchurl {
        name = "Lidarr.merge.${version}.linux-core-x64.tar.gz";
        url = "https://lidarr.servarr.com/v1/update/${branch}/updatefile?os=linux&runtime=netcore&arch=x64&version=${version}";
        hash = "sha256-yGsmXvqyBAgACFQ/5sqfaRbXB0tMHGTmkRDEyAc+Apg=";
      };
    });
    user = "media";
    group = "media";
  };
  services.prowlarr.enable = true;
  services.jellyseerr.enable = true;

  services.traefik.dynamicConfigOptions.http = {
    routers.radarr = {
      entryPoints = ["localsecure"];
      service = "radarr";
      rule = "Host(`radarr.eclipse.sefa.cloud`)";
    };
    routers.sonarr = {
      entryPoints = ["localsecure"];
      service = "sonarr";
      rule = "Host(`sonarr.eclipse.sefa.cloud`)";
    };
    routers.lidarr = {
      entryPoints = ["localsecure"];
      service = "lidarr";
      rule = "Host(`lidarr.eclipse.sefa.cloud`)";
    };
    routers.prowlarr = {
      entryPoints = ["localsecure"];
      service = "prowlarr";
      rule = "Host(`prowlarr.eclipse.sefa.cloud`)";
    };
    routers.jellyseerr = {
      entryPoints = ["websecure"];
      service = "jellyseerr";
      rule = "Host(`request.sefa.cloud`)";
    };
    services.radarr.loadBalancer.servers = [{url = "http://localhost:7878";}];
    services.sonarr.loadBalancer.servers = [{url = "http://localhost:8989";}];
    services.lidarr.loadBalancer.servers = [{url = "http://localhost:8686";}];
    services.prowlarr.loadBalancer.servers = [{url = "http://localhost:9696";}];
    services.jellyseerr.loadBalancer.servers = [{url = "http://localhost:${toString config.services.jellyseerr.port}";}];
  };
}
