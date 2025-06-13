{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.srvos.nixosModules.server
    inputs.srvos.nixosModules.hardware-hetzner-cloud-arm
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.nixos-facter-modules.nixosModules.facter
    inputs.agenix.nixosModules.age

    ./disks.nix
  ];

  facter.reportPath = ./facter.json;

  # this gets enabled by srvos
  services.cloud-init.enable = false;

  environment.systemPackages = [
    pkgs.kitty.terminfo
  ];

  networking.interfaces.enp1s0.useDHCP = true;

  system.stateVersion = "25.05";
}
