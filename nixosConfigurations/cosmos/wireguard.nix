{config, ...}: {
  age.secrets."wireguard.key" = {
    file = ../../secrets/${config.networking.hostName}/wireguard.key.age;
    owner = "systemd-network";
  };

  networking.firewall.allowedUDPPorts = [22701];
  networking.wireguard.interfaces.wg-scrumplex = {
    ips = ["10.255.255.11/24" "fd69:5efa:5efa:5efa::11/64"];
    listenPort = 22701;

    privateKeyFile = config.age.secrets."wireguard.key".path;

    peers = [
      {
        publicKey = "1FEGWV0GPVjc4NUprtuwg/bO0jUsUJbE74T6J4tgdVM=";
        allowedIPs = [
          "10.255.255.0/24"
          "fd69:5efa:5efa:5efa::0/64"
        ];
        endpoint = "scrumplex.net:22701";
        persistentKeepalive = 60;
      }
      {
        publicKey = "K/4AY/YimYKo2a8rufk0ygMp4dCRBfRQrrkLD36K5zI=";
        allowedIPs = [
          "10.255.255.10"
          "fd69:5efa:5efa:5efa::10"
        ];
      }
      {
        publicKey = "UKWQwi7cb6JfaxyGI3QIEOlIPzVNCihP+xqPvbv70nI=";
        allowedIPs = [
          "10.255.255.12"
          "fd69:5efa:5efa:5efa::12"
        ];
        endpoint = "10.10.10.12:22701";
        persistentKeepalive = 60;
      }
      {
        publicKey = "GQ2KrkMCj1b0tveuXe25yuabHx2xE68oXhHi1f/CTlM=";
        allowedIPs = [
          "10.255.255.21"
          "fd69:5efa:5efa:5efa::21"
        ];
      }
    ];
  };

  networking.firewall.trustedInterfaces = ["wg-scrumplex"];
}
