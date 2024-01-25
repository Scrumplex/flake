{pkgs, ...}: {
  imports = [./hardware-configuration.nix ./boot.nix ./specialisation/home-cache.nix ./swapfile.nix ./sway ./wireguard.nix];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  powerManagement.cpuFreqGovernor = "powersave";
  services.fwupd.enable = true;

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.gnome.gnome-keyring.enable = true;

  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    extraConfig = ''
      HandlePowerKey=suspend-then-hibernate
      PowerKeyIgnoreInhibited=yes
      LidSwitchIgnoreInhibited=no
    '';
  };

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=10m
  '';

  environment.systemPackages = with pkgs; [vim];

  profile.gpg.keygrips = ["BF9C6D61344A624956EB93594834D4D2AF5BD8C1"];

  system.stateVersion = "23.11";
}
