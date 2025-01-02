{
  config,
  pkgs,
  ...
}: {
  age.secrets."transmission-creds.json".file = ../../../secrets/eclipse/transmission-creds.json.age;

  services.transmission = {
    enable = true;
    user = "media";
    group = "media";
    package = pkgs.transmission_3.override {miniupnpc = pkgs.hello;};
    openPeerPorts = true;
    home = "/media/transmission";
    downloadDirPermissions = "770";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist = "torrent.eclipse.sefa.cloud";
      rpc-whitelist = "127.0.0.1,10.*.*.*";
      rpc-authentication-required = true;
      umask = 7;
    };
    credentialsFile = config.age.secrets."transmission-creds.json".path;
  };

  services.traefik.dynamicConfigOptions.http = {
    routers.torrent = {
      entryPoints = ["localsecure"];
      service = "torrent";
      rule = "Host(`torrent.eclipse.sefa.cloud`)";
    };
    services.torrent.loadBalancer.servers = [{url = "http://localhost:${toString config.services.transmission.settings.rpc-port}";}];
  };
}
