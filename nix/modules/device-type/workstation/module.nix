{config, ...}: {
  flake.modules.nixos.workstation = {
    imports = with config.flake.modules.nixos; [base desktop development gaming vr];
  };
}
