{config, ...}: {
  services.transmission = {
    enable = true;
    openPeerPorts = true;
    home = "/media/transmission";
    downloadDirPermissions = "770";
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-host-whitelist = "torrent.eclipse.lan";
      rpc-whitelist = "10.*.*.*";
      rpc-authentication-required = true;
      umask = 7;
    };
    credentialsFile = config.age.secrets."transmission-creds.json".path;
  };
}
