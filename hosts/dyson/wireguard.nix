{ config, ... }: {
  age.secrets.wg-scrumplex.file =
    ../../secrets/${config.networking.hostName}/wg.age;
  networking.wireguard.interfaces.wg-scrumplex = {
    ips = [ "10.255.255.21/24" "fd69:5efa:5efa:5efa::21/64" ];
    peers = [
      {
        allowedIPs = [ "10.255.255.0/24" "fd69:5efa:5efa:5efa::/64" ];
        endpoint = "scrumplex.net:22701";
        publicKey = "1FEGWV0GPVjc4NUprtuwg/bO0jUsUJbE74T6J4tgdVM=";
        persistentKeepalive = 60;
      }
      {
        allowedIPs = [ "10.255.255.2" "fd69:5efa:5efa:5efa::2" ];
        endpoint = "duckhub.io:22701";
        publicKey = "Ny2jkcZzKjKpEnZeUGDv98B2trGqARLsKlhFGkZX7x4=";
        persistentKeepalive = 60;
      }
      {
        allowedIPs = [ "10.255.255.11" "fd69:5efa:5efa:5efa::11" ];
        endpoint = "10.10.10.11:22701";
        publicKey = "SpTbip3iTqRM4qPFy4PtXI2WE9VmRVnfV931LPl3IWs=";
        persistentKeepalive = 60;
      }
    ];
    privateKeyFile = config.age.secrets.wg-scrumplex.path;
  };
}
