{fpConfig, ...}: {
  imports = [
    fpConfig.flake.modules.nixos.machine-galileo
    fpConfig.flake.modules.nixos.physical-server
  ];

  system.stateVersion = "26.05";
}
