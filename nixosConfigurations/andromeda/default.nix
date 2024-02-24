{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "andromeda";
    system = "x86_64-linux";

    modules = [
      ../common
      ../../home

      ./configuration.nix
    ];
  };
}
