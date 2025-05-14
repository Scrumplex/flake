{
  lib',
  self,
  ...
}: let
  inherit (builtins) attrValues;
in {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "sonic";
    modules =
      [
        (lib'.mkDeploy {
          targetHost = "root@sonic.lan";
          extraFlags = ["--verbose" "--print-build-logs"];
        })

        ../common
        ../common/nix.nix
        ../common/nix-index.nix
        ../common/openssh.nix
        ../common/pkgs
        ../common/regional.nix
        ../common/snapclient.nix
        ../common/server.nix
        ../common/utils.nix

        ./configuration.nix
      ]
      ++ attrValues self.nixosModules;
  };
}
