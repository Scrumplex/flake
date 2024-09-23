{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "eclipse";
    system = "x86_64-linux";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "eclipse.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })

        ../common
        ../common/nix.nix
        ../common/nix-index.nix
        ../common/nullmailer.nix
        ../common/postgres.nix
        ../common/server.nix
        ../common/traefik.nix
        ../common/upgrade.nix
        ../common/utils.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
