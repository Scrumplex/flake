{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.catppuccin;
in {
  options.roles.catppuccin = {
    enable = mkEnableOption "catppuccin role";
  };

  imports = [
    (mkAliasOptionModule ["roles" "catppuccin" "flavor"] ["hm" "catppuccin" "flavor"])
  ];

  config = mkIf cfg.enable {
    hm.programs.bat.catppuccin.enable = true;
    hm.programs.btop.catppuccin.enable = true;
    hm.programs.fish.catppuccin.enable = true;
    hm.programs.kitty.catppuccin.enable = true;
    hm.programs.neovim.catppuccin.enable = true;
  };
}
