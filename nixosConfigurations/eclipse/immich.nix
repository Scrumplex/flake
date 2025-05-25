{
  config,
  pkgs,
  ...
}: let
  nixpkgsWithImmich133 = import (pkgs.fetchFromGitHub {
    owner = "Scrumplex";
    repo = "nixpkgs";
    rev = "50cab7f910f7451480b1631c96df3f9867e754be";
    hash = "sha256-cX4CtfYjp4VdEm1fwxnJh9t/5bRKzr/03lu7PAMXeBs=";
  }) {inherit (pkgs) system;};
in {
  services.immich = {
    enable = true;
    mediaLocation = "/media/immich-library";
    port = 9121;
    package = nixpkgsWithImmich133.immich;
  };

  users.users.immich.extraGroups = ["video" "render"];

  services.traefik.dynamicConfigOptions.http = {
    routers.immich = {
      entryPoints = ["websecure"];
      service = "immich";
      rule = "Host(`immich.sefa.cloud`)";
    };
    services.immich.loadBalancer.servers = [{url = "http://${config.services.immich.host}:${toString config.services.immich.port}";}];
  };

  services.borgbackup.jobs.borgbase.paths = ["/media/immich-library"];
}
