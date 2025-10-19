{
  self,
  lib,
  ...
}: let
  inherit (lib) escapeShellArgs filterAttrs mapAttrs' nameValuePair;

  validConfigurations = filterAttrs (_: nixosSystem: nixosSystem._module.args ? deploy) self.nixosConfigurations;

  mkDeploymentApp = self: name: deploy: pkgs: {
    type = "app";
    program = pkgs.writeShellApplication {
      name = "deploy-${name}";

      runtimeInputs = with pkgs; [
        nixos-rebuild-ng
      ];

      text = ''
        goal="''${1:-switch}"
        flake="${self}"
        name="${name}"
        targetHost="${deploy.targetHost}"
        extraFlags=(${escapeShellArgs (deploy.extraFlags or [])})

        nixos-rebuild "$goal" --flake "$flake#$name" --target-host "$targetHost" "''${extraFlags[@]}"
      '';
    };
  };
in {
  perSystem = {pkgs, ...}: {
    apps = mapAttrs' (name: nixosSystem: nameValuePair "deploy-${name}" (mkDeploymentApp self name nixosSystem._module.args.deploy pkgs)) validConfigurations;
  };
}
