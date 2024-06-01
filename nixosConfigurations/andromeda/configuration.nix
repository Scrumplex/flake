{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./borg.nix
    ./desktop/sway.nix
    ./desktop/waybar.nix
    ./wireguard.nix

    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  hardware.amdgpu.amdvlk = false;
  profile.vr.enableHighPrioKernelPatch = true;

  hardware.opengl.vdpau.driverName = "radeonsi";

  networking.useNetworkd = true;
  systemd.network.wait-online.anyInterface = true;
  services.resolved.dnssec = "false";

  hardware.bluetooth.enable = true;

  programs.partition-manager.enable = true;

  fileSystems = {
    "/media/DATA" = {
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_2T00_213894440406-part1";
      fsType = "ext4";
      options = ["defaults" "noauto" "x-systemd.automount"];
    };
  };

  powerManagement.cpuFreqGovernor = "schedutil";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.avahi.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 2234;
      to = 2239;
    }
  ];

  services.logind.extraConfig = ''
    HandlePowerKey=suspend
  '';

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [virtiofsd];
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  profile.gpg.keygrips = ["EA9F43D0C2AEA7D44EDE68FAAAD1776402F99A4E"];

  system.stateVersion = "23.11";
}
