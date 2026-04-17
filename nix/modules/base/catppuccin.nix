{inputs, ...}: {
  flake.modules.nixos."base" = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];

    catppuccin = {
      flavor = "mocha";
      accent = "blue";
    };
  };

  flake.modules.homeManager."base" = {osConfig, ...}: {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];

    catppuccin = {
      inherit (osConfig.catppuccin) flavor accent;
    };
  };
}
