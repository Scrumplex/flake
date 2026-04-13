{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nix-darwin scrumpkgs;
in {
  flake.darwinConfigurations = {
    LMDT00179100C = nix-darwin.lib.darwinSystem {
      modules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        ./LMDT00179100C
      ];

      specialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };
  };
}
