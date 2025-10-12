{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "eclipse";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "eclipse.sefa.cloud";
          extraFlags = ["--verbose" "--print-build-logs" "--use-substitutes"];
        })

        ../common
        ../common/nix.nix
        ../common/nix-index.nix
        ../common/openssh.nix
        ../common/pkgs
        ../common/postgres.nix
        ../common/regional.nix
        ../common/remote-build-provider.nix
        ../common/server.nix
        ../common/traefik.nix
        ../common/upgrade.nix
        ../common/utils.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
