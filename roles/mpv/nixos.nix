{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.roles.mpv;
in {
  config = mkIf cfg.enable {
    hm.services.jellyfin-mpv-shim.enable = true;
  };
}
