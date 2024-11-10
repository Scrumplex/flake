{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./borg.nix
    ./desktop/sway.nix
    ./desktop/waybar.nix
    ./disks.nix
    ./networking.nix
    ./wireguard.nix

    inputs.nixos-facter-modules.nixosModules.facter
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.srvos.nixosModules.desktop
  ];

  facter.reportPath = ./facter.json;
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  profile.vr.enableHighPrioKernelPatch = true;
  profile.nix.enableMyCache = true;

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };
  hardware.opengl.vdpau.driverName = "radeonsi";

  powerManagement.cpuFreqGovernor = "schedutil";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.logind.powerKey = "suspend";

  system.stateVersion = "23.11";
}
