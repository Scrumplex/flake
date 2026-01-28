{inputs, ...}: {
  flake.modules.nixos."machine-galileo" = {
    imports = [
      inputs.srvos.nixosModules.server
    ];
    # Disable serial console
    srvos.boot.consoles = ["tty0"];
  };
}
