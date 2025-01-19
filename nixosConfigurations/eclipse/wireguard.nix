{config, ...}: {
  age.secrets."wireguard.key" = {
    file = ../../secrets/eclipse/wireguard.key.age;
    owner = "systemd-network";
  };

  age.secrets."wg-backdoor.key".file = ../../secrets/eclipse/wg-backdoor.key.age;

  networking.firewall.allowedUDPPorts = [22701];
  networking.wireguard.interfaces.wg-scrumplex = {
    ips = ["10.255.255.12/24" "fd69:5efa:5efa:5efa::12/64"];
    listenPort = 22701;

    # TODO: rotate
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
        publicKey = "SpTbip3iTqRM4qPFy4PtXI2WE9VmRVnfV931LPl3IWs=";
        allowedIPs = [
          "10.255.255.11"
          "fd69:5efa:5efa:5efa::11"
        ];
        endpoint = "10.10.10.11:22701";
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

  networking.wireguard.interfaces.wg-backdoor = {
    ips = ["10.10.11.12/24"];

    privateKeyFile = config.age.secrets."wg-backdoor.key".path;

    peers = [
      {
        publicKey = "mzH2Pbsr4qow6Vhf1WQD0F/nYWFy6NlLMn4cq6/d5Rs=";
        allowedIPs = [
          "10.10.11.0/24"
        ];
        endpoint = "arson.sefa.cloud:42069";
        persistentKeepalive = 60;
      }
    ];
  };

  networking.firewall.trustedInterfaces = ["wg-scrumplex" "wg-backdoor"];
}
