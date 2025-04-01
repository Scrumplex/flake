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
    hm.catppuccin.bat.enable = true;
    hm.catppuccin.btop.enable = true;
    hm.catppuccin.fish.enable = true;
    hm.catppuccin.kitty.enable = true;
  };
}
