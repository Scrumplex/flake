{
  fpConfig,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./borg.nix
    ./desktop/niri.nix
    ./desktop/swayidle.nix
    ./desktop/waybar.nix
    ./disks.nix
    ./networking.nix
    ./ustreamer.nix
    ./wireguard.nix

    fpConfig.flake.modules.nixos.workstation

    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.srvos.nixosModules.desktop
  ];

  hardware.facter = {
    reportPath = ./facter.json;
    detected.dhcp.enable = false;
  };
  hardware.enableRedistributableFirmware = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  hardware.amdgpu = {
    initrd.enable = true;
    #opencl.enable = true;
  };
  hardware.opengl.vdpau.driverName = "radeonsi";

  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  services.power-profiles-daemon.enable = true;

  services.logind.settings.Login.HandlePowerKey = "suspend";

  system.stateVersion = "23.11";
}
