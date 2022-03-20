{ config, pkgs, lib, ... }:

let
  listenPort = 80;
in {
  networking.firewall.allowedTCPPorts = [ listenPort ];

  services.sslh = {
    enable = true;
    transparent = true;
    port = listenPort;
    appendConfig = ''
      protocols:
      (
        { name: "ssh"; service: "ssh"; host: "localhost"; port: "22701"; probe: "builtin"; },
        { name: "http"; host: "localhost"; port: "1080"; probe: "builtin"; },
      );
    '';
  };
}

