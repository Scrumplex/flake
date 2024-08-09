{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge;
  commonVHost = {
    # TODO: use overlay once Nixpkgs Node.js tooling works again
    root = pkgs.scrumplex-website;
    locations = {
      "~* \.html$".extraConfig = ''
        expires 1h;
      '';
      "~* \.(css|js|svg|png|eot|woff2?)$".extraConfig = ''
        expires max;
      '';
    };
    extraConfig = ''
      add_header Onion-Location http://oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion$request_uri;
    '';
  };
in {
  age.secrets."scrumplex-hs_ed25519_secret_key".file = ../../secrets/universe/scrumplex-hs_ed25519_secret_key.age;

  nixpkgs.overlays = [inputs.scrumplex-website.overlays.default];

  services.nginx.virtualHosts = {
    "scrumplex.net" = mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      commonVHost
    ];
    "oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion" = mkMerge [
      commonVHost
    ];
    "live.scrumplex.net" = mkMerge [
      config.common.nginx.vHost
      config.common.nginx.sslVHost
      {
        locations."/" = {
          proxyPass = "http://localhost:3333";
          proxyWebsockets = true;
        };
      }
    ];
  };

  services.tor = {
    enable = true;
    relay.onionServices."scrumplex" = {
      map = [
        {
          port = 80;
          target = {
            addr = "localhost";
            port = 80;
          };
        }
      ];
      secretKey = config.age.secrets."scrumplex-hs_ed25519_secret_key".path;
    };
  };

  virtualisation.oci-containers.containers.ovenmediaengine = {
    image = config.virtualisation.oci-containers.externalImages.images."ovenmediaengine".ref;
    environment = {
      OME_SRT_PROV_PORT = "1935";
      OME_DISTRIBUTION = "live.scrumplex.net";
      OME_APPLICATION = "scrumplex";
    };
    ports = [
      "3333:3333" # WebRTC Signaling
      "3478:3478" # WebRTC Relay
      "1935:1935" # RTMP Ingest
      "10000-10005:10000-10005/udp" # WebRTC ICE
    ];
    volumes = [
      "${./scrumplex-live-Server.xml}:/opt/ovenmediaengine/bin/origin_conf/Server.xml"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      3478
    ];
    allowedUDPPortRanges = [
      {
        from = 10000;
        to = 10005;
      }
    ];
  };
}
