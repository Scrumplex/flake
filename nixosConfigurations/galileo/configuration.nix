{fpConfig, ...}: {
  imports = [
    fpConfig.flake.modules.nixos.machine-galileo
    fpConfig.flake.modules.nixos.physical-server
    fpConfig.flake.modules.nixos.ext-traefik
  ];

  system.stateVersion = "26.05";
}
