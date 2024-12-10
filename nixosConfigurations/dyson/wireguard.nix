{config, ...}: {
  age.secrets.wg-scrumplex = {
    file = ../../secrets/${config.networking.hostName}/wg.age;
    owner = "systemd-network";
  };

  networking.wireguard.interfaces.wg-scrumplex = {
    ips = ["10.255.255.21/24" "fd69:5efa:5efa:5efa::21/64"];
    peers = [
      {
        allowedIPs = ["10.255.255.0/24" "fd69:5efa:5efa:5efa::/64"];
        endpoint = "scrumplex.net:22701";
        publicKey = "1FEGWV0GPVjc4NUprtuwg/bO0jUsUJbE74T6J4tgdVM=";
        persistentKeepalive = 60;
      }
    ];
    privateKeyFile = config.age.secrets.wg-scrumplex.path;
  };
}
