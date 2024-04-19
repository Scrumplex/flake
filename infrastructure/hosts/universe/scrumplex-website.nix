{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkMerge;
  commonVHost = {
    quic = true;
    http3_hq = true;
    root = inputs.scrumplex-website.packages.${pkgs.system}.scrumplex-website;
    extraConfig = ''
      add_header Onion-Location http://oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion$request_uri;

      location ~* \.html$ {
        expires 1h;
      }
      location ~* \.(css|js|svg|png|eot|woff2?)$ {
        expires max;
      }
    '';
  };
in {
  age.secrets."scrumplex-hs_ed25519_secret_key".file = ../../secrets/universe/scrumplex-hs_ed25519_secret_key.age;

  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts = {
    "scrumplex.net" = mkMerge [
      commonVHost
      {
        forceSSL = true;
        enableACME = true;
      }
    ];
    "oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion" = mkMerge [
      commonVHost
    ];
    "live.scrumplex.net" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://localhost:3333";
        proxyWebsockets = true;
      };
    };
  };

  services.tor = {
    enable = true;
    relay.onionServices."scrumplex" = {
      map = [
        {
          port = 80;
          target = {
            addr = "localhost";
            port = 81;
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
