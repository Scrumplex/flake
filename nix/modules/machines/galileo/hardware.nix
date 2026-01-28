{inputs, ...}: {
  flake.modules.nixos."machine-galileo" = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-pc-ssd
      inputs.nixos-hardware.nixosModules.common-cpu-intel
      "${inputs.nixos-hardware}/common/gpu/intel/skylake"
    ];
  };
}
