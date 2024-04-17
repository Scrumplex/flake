{
  config,
  inputs,
  pkgs,
  ...
}: {
  age.secrets."scrumplex-hs_ed25519_secret_key".file = ../../secrets/universe/scrumplex-hs_ed25519_secret_key.age;

  # TODO: use overlay once we are on 24.05
  services.nginx.virtualHosts."scrumplex.net" = {
    serverAliases = ["oysap5oclxaouxpuyykckncptwvt5cfwqyyckolly3hy5aq5poyvilid.onion"];
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
    labels = {
      "traefik.enable" = "true";
      "traefik.http.routers.ovenmediaengine.rule" = "Host(`live.scrumplex.net`)";
      "traefik.http.routers.ovenmediaengine.entrypoints" = "websecure";
      "traefik.http.services.ovenmediaengine.loadbalancer.server.port" = "3333";
    };
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

  services.traefik.dynamicConfigOptions.http = {
    routers.scrumplex-website = {
      entryPoints = ["websecure"];
      service = "nginx";
      rule = "Host(`scrumplex.net`)";
    };
  };
}
