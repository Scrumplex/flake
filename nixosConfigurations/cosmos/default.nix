{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "cosmos";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "cosmos.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })

        ../common
        ../common/nix.nix
        ../common/nix-index.nix
        ../common/nullmailer.nix
        ../common/server.nix
        ../common/traefik.nix
        ../common/upgrade.nix
        ../common/utils.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
