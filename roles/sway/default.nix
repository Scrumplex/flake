{lib, ...}: let
  inherit (lib) types;
  inherit (lib.modules) mkAliasOptionModule;
  inherit (lib.options) mkEnableOption mkOption;
in {
  options.roles.sway = {
    enable = mkEnableOption "sway role";

    wallpaper = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        Wallpaper used for all outputs
      '';
    };
  };

  imports = [
    (mkAliasOptionModule ["roles" "sway" "config"] ["hm" "wayland" "windowManager" "sway" "config"])
  ];
}
