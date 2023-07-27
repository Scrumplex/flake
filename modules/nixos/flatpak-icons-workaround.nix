{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  cfg = config.workarounds.flatpak-icons;

  mkRoSymBind = path: {
    device = path;
    fsType = "fuse.bindfs";
    options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
  };
  aggregatedFonts = pkgs.buildEnv {
    name = "system-fonts";
    paths = config.fonts.packages;
    pathsToLink = ["/share/fonts"];
  };
in {
  meta.maintainers = [lib.maintainers.Scrumplex];
  options.workarounds.flatpak-icons = {
    enable =
      mkEnableOption "flatpak icons workaround"
      // {
        default = config.services.flatpak.enable;
        defaultText = "config.services.flatpak.enable";
      };

    bindfsPackage = mkPackageOption pkgs "bindfs" {};
  };

  config = mkIf cfg.enable {
    system.fsPackages = [cfg.bindfsPackage];
    fileSystems = {
      # Create an FHS mount to support flatpak host icons/fonts
      "/usr/share/icons" = mkRoSymBind (config.system.path + "/share/icons");
      "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
    };
  };
}
