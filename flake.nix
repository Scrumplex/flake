{
  inputs = {
    agenix.inputs.darwin.follows = "darwin";
    agenix.inputs.home-manager.follows = "home-manager";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    catppuccin-qt5ct.flake = false;
    catppuccin-qt5ct.url = "github:catppuccin/qt5ct";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:LnL7/nix-darwin";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks.inputs.flake-compat.follows = "";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    honeylinks-website.inputs.flake-parts.follows = "flake-parts";
    honeylinks-website.inputs.nixpkgs.follows = "nixpkgs";
    honeylinks-website.inputs.pre-commit-hooks.follows = "git-hooks";
    honeylinks-website.url = "git+https://codeberg.org/Scrumplex/honeylinks.git";
    import-tree.url = "github:vic/import-tree";
    inhibridge.inputs.flake-parts.follows = "flake-parts";
    inhibridge.inputs.git-hooks.follows = "git-hooks";
    inhibridge.inputs.nixpkgs.follows = "nixpkgs";
    inhibridge.url = "git+https://codeberg.org/Scrumplex/inhibridge.git";
    jovian.inputs.nixpkgs.follows = "nixpkgs";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    lanzaboote.inputs.pre-commit.follows = "git-hooks";
    lanzaboote.url = "github:nix-community/lanzaboote";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.url = "github:sodiboo/niri-flake";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-minecraft.inputs.flake-compat.follows = "";
    nix-minecraft.inputs.nixpkgs.follows = "nixpkgs";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs-fork-crashdump.url = "github:Scrumplex/nixpkgs/nixos/crashdump";
    nixpkgs-fork-traefik.url = "github:NixOS/nixpkgs/cfb6394148dbd3fe2b58bd95f4529d8a8f15c3d7";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-xr.inputs.flake-compat.follows = "";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.inputs.flake-parts.follows = "flake-parts";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixvim.url = "github:nix-community/nixvim";
    openwrt-imagebuilder.inputs.flake-parts.follows = "flake-parts";
    openwrt-imagebuilder.inputs.nixpkgs.follows = "nixpkgs";
    openwrt-imagebuilder.url = "github:astro/nix-openwrt-imagebuilder";
    prismlauncher.inputs.nixpkgs.follows = "nixpkgs";
    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
    scrumpkgs.inputs.flake-compat.follows = "";
    scrumpkgs.inputs.flake-parts.follows = "flake-parts";
    scrumpkgs.inputs.nixpkgs.follows = "nixpkgs";
    scrumpkgs.inputs.pre-commit-hooks.follows = "git-hooks";
    scrumpkgs.url = "github:Scrumplex/pkgs";
    scrumplex-website-ng.inputs.flake-parts.follows = "flake-parts";
    scrumplex-website-ng.inputs.nixpkgs.follows = "nixpkgs";
    scrumplex-website-ng.inputs.pre-commit-hooks.follows = "git-hooks";
    scrumplex-website-ng.url = "git+https://tangled.org/scrumplex.net/website?ref=refs/heads/refactor/vite";
    scrumplex-website.inputs.flake-parts.follows = "flake-parts";
    scrumplex-website.inputs.nixpkgs.follows = "nixpkgs";
    scrumplex-website.inputs.pre-commit-hooks.follows = "git-hooks";
    scrumplex-website.url = "git+https://codeberg.org/Scrumplex/website.git";
    skinprox.inputs.flake-parts.follows = "flake-parts";
    skinprox.inputs.nixpkgs.follows = "nixpkgs";
    skinprox.inputs.pre-commit-hooks.follows = "git-hooks";
    skinprox.url = "git+https://codeberg.org/Scrumplex/skinprox.git";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
    srvos.url = "github:nix-community/srvos";
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

        ./nixosConfigurations/eclipse
        ./nixosConfigurations/galileo
        ./nixosConfigurations/universe

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
