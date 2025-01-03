{config, ...}: let
  ifName = "wg-scrumplex";
  port = 22701;

  ip4 = "10.255.255.1/24";
  ip6 = "fd69:5efa:5efa:5efa::1/64";

  extIfName = "ens3";
in {
  age.secrets."wireguard.key" = {
    file = ../../secrets/universe/wireguard.key.age;
    owner = "systemd-network";
  };

  networking = {
    nat = {
      enable = true;
      enableIPv6 = true;
      externalInterface = extIfName;
      internalInterfaces = [ifName];
    };
    firewall.allowedUDPPorts = [port];
    wireguard.interfaces.${ifName} = {
      ips = [ip4 ip6];
      listenPort = port;

      privateKeyFile = config.age.secrets."wireguard.key".path;

      peers = [
        {
          publicKey = "nqA7cdeR7JztKE+DFhBN1NIxXYafBOQypNHNP+/osAE=";
          allowedIPs = ["10.255.255.3" "fd69:5efa:5efa:5efa::3"];
        }
        {
          publicKey = "K/4AY/YimYKo2a8rufk0ygMp4dCRBfRQrrkLD36K5zI=";
          allowedIPs = ["10.255.255.10" "fd69:5efa:5efa:5efa::10"];
        }
        {
          publicKey = "SpTbip3iTqRM4qPFy4PtXI2WE9VmRVnfV931LPl3IWs=";
          allowedIPs = ["10.255.255.11" "fd69:5efa:5efa:5efa::11"];
        }
        {
          publicKey = "UKWQwi7cb6JfaxyGI3QIEOlIPzVNCihP+xqPvbv70nI=";
          allowedIPs = ["10.255.255.12" "fd69:5efa:5efa:5efa::12"];
        }
        {
          publicKey = "W/9mR39AqBBOc1eyWZe9qbZGEuhuQqCUPKHUNymsmWo=";
          allowedIPs = ["10.255.255.20" "fd69:5efa:5efa:5efa::20"];
        }
        {
          publicKey = "GQ2KrkMCj1b0tveuXe25yuabHx2xE68oXhHi1f/CTlM=";
          allowedIPs = ["10.255.255.21" "fd69:5efa:5efa:5efa::21"];
        }
      ];
    };

    firewall.trustedInterfaces = [ifName];
  };
}
