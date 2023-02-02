{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [ 22701 ];
  networking.wireguard.interfaces.wg-scrumplex = {
    ips = [ "10.255.255.2/24" "fd69:5efa:5efa:5efa::2/64" ];
    listenPort = 22701;

    privateKeyFile = config.age.secrets."wireguard.key".path;

    peers = [
      {
        publicKey = "1FEGWV0GPVjc4NUprtuwg/bO0jUsUJbE74T6J4tgdVM=";
        allowedIPs = [ "10.255.255.0/24" "fd69:5efa:5efa:5efa::0/64" ];
        endpoint = "scrumplex.net:22701";
        persistentKeepalive = 60;
      }
      {
        publicKey = "K/4AY/YimYKo2a8rufk0ygMp4dCRBfRQrrkLD36K5zI=";
        allowedIPs = [ "10.255.255.10" "fd69:5efa:5efa:5efa::10" ];
      }
      {
        publicKey = "SpTbip3iTqRM4qPFy4PtXI2WE9VmRVnfV931LPl3IWs=";
        allowedIPs = [ "10.255.255.11" "fd69:5efa:5efa:5efa::11" ];
      }
      {
        publicKey = "W/9mR39AqBBOc1eyWZe9qbZGEuhuQqCUPKHUNymsmWo=";
        allowedIPs = [ "10.255.255.20" "fd69:5efa:5efa:5efa::20" ];
      }
      {
        publicKey = "L7A0HON+NBxmTmwjtuKreThu+V45SYhIduEjI/HyzCc=";
        allowedIPs = [ "10.255.255.21" "fd69:5efa:5efa:5efa::21" ];
      }
    ];
  };

  networking.firewall.trustedInterfaces = [ "wg-scrumplex" ];
}
