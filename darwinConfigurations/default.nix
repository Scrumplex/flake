{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nix-darwin scrumpkgs;
in {
  flake.darwinConfigurations = {
    LMDT0028AADFC = nix-darwin.lib.darwinSystem {
      modules = [
        {
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nixpkgs.hostPlatform = "aarch64-darwin";
        }

        ./LMDT0028AADFC
      ];

      specialArgs = {
        inherit inputs;
        lib' = scrumpkgs.lib;
      };
    };
  };
}
