{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "dyson";
    system = "x86_64-linux";

    modules = [
      ../common
      ../../home

      ./configuration.nix
    ];
  };
}
