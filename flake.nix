{
  inputs = {
    agenix = {
      url = "github:ryantm/agenix";
      inputs.darwin.follows = "darwin";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin-qt5ct = {
      url = "github:catppuccin/qt5ct";
      flake = false;
    };
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    honeylinks-website = {
      url = "git+https://codeberg.org/Scrumplex/honeylinks.git";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    import-tree.url = "github:vic/import-tree";
    inhibridge = {
      url = "git+https://codeberg.org/Scrumplex/inhibridge.git";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      # intentionally not following our nixpkgs for cache
      url = "github:nix-community/lanzaboote";
      inputs.pre-commit.follows = "git-hooks";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-xr = {
      url = "github:nix-community/nixpkgs-xr";
      inputs.flake-compat.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    openwrt-imagebuilder = {
      url = "github:astro/nix-openwrt-imagebuilder";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    scrumpkgs = {
      url = "github:Scrumplex/pkgs";
      inputs.flake-compat.follows = "";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    scrumplex-website = {
      url = "git+https://codeberg.org/Scrumplex/website.git";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    scrumplex-website-ng = {
      url = "git+https://codeberg.org/Scrumplex/website.git?ref=astro";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    skinprox = {
      url = "git+https://codeberg.org/Scrumplex/skinprox.git";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "git-hooks";
    };
    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.git-hooks.flakeModule
        ./flakeDeploy.nix

        ./lib
        ./nixosModules
        ./pkgs

        ./nixosConfigurations/andromeda
        ./nixosConfigurations/dyson
        ./nixosConfigurations/fornax

        ./nixosConfigurations/cosmos
        ./nixosConfigurations/eclipse
        ./nixosConfigurations/galileo
        ./nixosConfigurations/universe
        ./nixosConfigurations/centauri

        ./darwinConfigurations/builder

        ./openwrt

        ./parts/checks.nix
        ./parts/dev.nix

        (inputs.import-tree ./nix)
      ];

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    };
}
