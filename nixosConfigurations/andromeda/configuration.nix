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
    ./disks.nix
    ./wireguard.nix

    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  profile.vr.enableHighPrioKernelPatch = true;
  profile.amdgpu.patches = [
    (pkgs.fetchpatch2 {
      name = "fix-amdgpu-crash.patch";
      url = "https://gitlab.freedesktop.org/agd5f/linux/-/commit/334b56cea5d9df5989be6cf1a5898114fa70ad98.patch";
      hash = "";
    })
  ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  hardware.opengl.vdpau.driverName = "radeonsi";

  networking.useNetworkd = true;
  systemd.network.wait-online.anyInterface = true;
  services.resolved.dnssec = "false";

  hardware.bluetooth.enable = true;

  programs.partition-manager.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.avahi.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 2234;
      to = 2239;
    }
  ];

  services.logind.powerKey = "suspend";

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
      vhostUserPackages = with pkgs; [virtiofsd];
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  system.stateVersion = "23.11";
}
