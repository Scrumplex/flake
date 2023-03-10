{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./boot.nix ./nix.nix ./swapfile.nix ./wireguard.nix];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  powerManagement.cpuFreqGovernor = "powersave";
  services.fwupd.enable = true;

  networking.networkmanager.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services = {
    login.gnupg = {
      enable = true;
      noAutostart = true;
      storeOnly = true;
    };
    gtklock.gnupg = config.security.pam.services.login.gnupg;
  };

  services.logind.extraConfig = ''
    HandlePowerKey=suspend-then-hibernate
    HandleLidSwitch=suspend-then-hibernate
    PowerKeyIgnoreInhibited=yes
    LidSwitchIgnoreInhibited=no
  '';

  environment.systemPackages = with pkgs; [vim];

  system.stateVersion = "23.05";
}
