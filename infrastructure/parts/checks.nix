{
  lib,
  self,
  ...
}: {
  perSystem = {system, ...}: {
    checks = lib.mapAttrs' (name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel) ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
  };
}
