{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.options) mkEnableOption mkPackageOption;
  inherit (lib.modules) mkIf;

  cfg = config.services.jellyfin-mpv-shim;
in {
  meta.maintainers = [lib.maintainers.Scrumplex];

  options.services.jellyfin-mpv-shim = {
    enable = mkEnableOption "jellyfin-mpv-shim";

    package = mkPackageOption pkgs "jellyfin-mpv-shim" {};
  };

  config = mkIf cfg.enable {
    systemd.user.services."jellyfin-mpv-shim" = {
      Unit = {
        Description = "Jellyfin MPV Shim";
        Documentation = "https://github.com/jellyfin/jellyfin-mpv-shim";
      };
      Service.ExecStart = "${cfg.package}/bin/jellyfin-mpv-shim";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
