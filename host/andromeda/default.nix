{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [./hardware-configuration.nix ./harmonia.nix ./wireguard.nix];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  boot.kernelPatches = [inputs.scrumpkgs.kernelPatches.cap_sys_nice_begone];

  powerManagement.cpuFreqGovernor = "schedutil";
  hardware.amdgpu.amdvlk = false;

  hardware.opengl.vdpau.driverName = "radeonsi";

  networking.useNetworkd = true;
  systemd.network.wait-online.anyInterface = true;
  services.resolved.dnssec = "false";

  hardware.bluetooth.enable = true;
  hardware.xpadneo.enable = true;

  programs.partition-manager.enable = true;

  fileSystems = {
    "/media/DATA" = {
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_2T00_213894440406-part1";
      fsType = "ext4";
      options = ["defaults" "noauto" "x-systemd.automount"];
    };
  };

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

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

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
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

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 2234;
      to = 2239;
    }
  ];

  services.monado.enable = true;

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [wlx-overlay-x];

  system.stateVersion = "23.11";
}
