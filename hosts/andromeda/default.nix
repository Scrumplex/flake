{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  time.timeZone = "Europe/Berlin";

  fileSystems = {
    "/media/DATA" = {
      device =
        "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_50026B768299115B-part1";
      fsType = "ext4";
      options = [ "defaults" "noauto" "x-systemd.automount" ];
    };
    "/media/DATA2" = {
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_2T00_213894440406-part1";
      fsType = "ext4";
      options = [ "defaults" "noauto" "x-systemd.automount" ];
    };
  };

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

  console = { keyMap = "us"; };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gtklock.gnupg = { # also enables support for gtklock!
    enable = true;
    noAutostart = true;
    storeOnly = true;
  };
  security.pam.services.login.gnupg = {
    enable = true;
    noAutostart = true;
    storeOnly = true;
  };

  programs.steam.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  hardware.opengl.enable = true;
  programs.sway.enable = true;

  programs.adb.enable = true;

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        desiredgov = "performance";
        softrealtime = "on";
        renice = 10;
        ioprio = 1;
        inhibit_screensaver = 0;
      };
      custom = {
        start = ''${pkgs.libnotify}/bin/notify-send "GameMode started"'';
        stop = ''${pkgs.libnotify}/bin/notify-send "GameMode ended"'';
      };
    };
  };

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

