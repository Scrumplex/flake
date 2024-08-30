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
    # https://gitlab.freedesktop.org/drm/amd/-/issues/3142#note_2547420
    (pkgs.fetchpatch {
      url = "https://gitlab.freedesktop.org/-/project/4522/uploads/d5efc5831caa89538f5e68ab1905e73f/0001-drm-amd-display-Avoid-race-between-dcn10_set_drr-and.patch";
      hash = "sha256-KkKEFnM+YavdmFOszZEh528uC0mzUvNG+4uI/R4vUPU=";
    })
  ];
  profile.nix.enableMyCache = true;

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
