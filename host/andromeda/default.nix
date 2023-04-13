{
  config,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./nix-serve.nix ./wireguard.nix];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linux_zen_scrumplex;

  powerManagement.cpuFreqGovernor = "schedutil";
  hardware.amdgpu.amdvlk = false;

  networking.useNetworkd = true;
  systemd.network.wait-online.anyInterface = true;
  services.resolved.dnssec = "false";

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;

  fileSystems = {
    "/media/DATA" = {
      device = "/dev/disk/by-id/ata-KINGSTON_SA400S37960G_50026B768299115B-part1";
      fsType = "ext4";
      options = ["defaults" "noauto" "x-systemd.automount"];
    };
    "/media/DATA2" = {
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_2T00_213894440406-part1";
      fsType = "ext4";
      options = ["defaults" "noauto" "x-systemd.automount"];
    };
  };

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [samsung-unified-linux-driver_1_00_37];
  };
  services.avahi.enable = true;

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
    HandlePowerKey=suspend
  '';

  virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [vim];

  system.stateVersion = "23.05";
}
