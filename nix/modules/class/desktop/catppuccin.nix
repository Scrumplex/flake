{inputs, ...}: {
  flake.modules.nixos.desktop = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];

    catppuccin = {
      flavor = "mocha";
      accent = "blue";
    };
  };

  flake.modules.homeManager.desktop = {osConfig, ...}: {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];

    catppuccin = {
      inherit (osConfig.catppuccin) flavor accent;
    };
  };
}
