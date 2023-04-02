{config, ...}: {
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
        publicKey = "Ny2jkcZzKjKpEnZeUGDv98B2trGqARLsKlhFGkZX7x4=";
        allowedIPs = [
          "10.255.255.2"
          "fd69:5efa:5efa:5efa::2"
        ];
        endpoint = "duckhub.io:22701";
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
