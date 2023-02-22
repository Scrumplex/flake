{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./boot.nix ./swapfile.nix ./wireguard.nix ];

  hardware.enableRedistributableFirmware = true;

  powerManagement.cpuFreqGovernor = "powersave";

  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  networking.networkmanager.enable = true;

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

  services.fwupd.enable = true;

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

