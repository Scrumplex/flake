{ config, pkgs, lib, ... }:

{
  networking.firewall.allowedUDPPorts = [ 22701 ];
  networking.wireguard.interfaces.wg-scrumplex = {
    ips = [ "10.255.255.1/24" "fd69:5efa:5efa:5efa::1/64" ];
    listenPort = 22701;

    privateKeyFile = config.age.secrets."wireguard.key".path;

    peers = [
      {
        publicKey = "Ny2jkcZzKjKpEnZeUGDv98B2trGqARLsKlhFGkZX7x4=";
        allowedIPs = [ "10.255.255.2" "fd69:5efa:5efa:5efa::2" ];
        endpoint = "duckhub.io:22701";
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
        publicKey = "GQ2KrkMCj1b0tveuXe25yuabHx2xE68oXhHi1f/CTlM=";
        allowedIPs = [ "10.255.255.21" "fd69:5efa:5efa:5efa::21" ];
      }
    ];
  };

  networking.firewall.trustedInterfaces = [ "wg-scrumplex" ];
}
