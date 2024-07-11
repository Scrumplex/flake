{
  description = "scrumplex.net Infrastructure";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    skinprox = {
      url = "git+https://codeberg.org/Scrumplex/skinprox.git";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    scrumplex-website = {
      url = "git+https://codeberg.org/Scrumplex/website.git";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    honeylinks-website = {
      url = "git+https://codeberg.org/Scrumplex/honeylinks.git";
      inputs.nixpkgs.follows = "nixpkgs-stable";
      inputs.flake-parts.follows = "flake-parts";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    prism-meta = {
      url = "github:PrismLauncher/meta";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
    };
    refraction = {
      url = "github:PrismLauncher/refraction";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    buildbot-nix = {
      url = "github:Mic92/buildbot-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
        ./nixosHosts-flake-module.nix

        ./modules
        ./pkgs

        ./hosts/cosmos
        ./hosts/eclipse
        ./hosts/universe

        ./parts/checks.nix
        ./parts/dev.nix
      ];

      systems = [
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    };
}
