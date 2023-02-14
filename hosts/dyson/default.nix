{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  time.timeZone = "Europe/Berlin";

  networking.wireguard.interfaces.wg-scrumplex = {
    ips = [ "10.255.255.10/24" "fd69:5efa:5efa:5efa::10/64" ];
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
    privateKeyFile = "/etc/nixos/wg-scrumplex.key";
  };

  networking.networkmanager.enable = true;

  console.keyMap = "us";

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable = true;

  security.pam.services = let
    pamGnupgOpts = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };
  in {
    gtklock.gnupg = pamGnupgOpts;
    login.gnupg = pamGnupgOpts;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [ vim ];

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  services.openssh.enable = true;

  networking.firewall.allowedTCPPorts = [ 22000 ];
  networking.firewall.allowedUDPPorts = [ 21027 22000 ];

  system.stateVersion = "23.05";
}

