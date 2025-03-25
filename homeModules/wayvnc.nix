{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkEnableOption mkIf mkOption mkPackageOption types;

  cfg = config.services.wayvnc;

  format = pkgs.formats.keyValue {};
in {
  options.services.wayvnc = {
    enable = mkEnableOption "wayvnc VNC server";

    package = mkPackageOption pkgs "wayvnc" {};

    autoStart = mkEnableOption "autostarting of wayvnc";

    settings = mkOption {
      type = types.submodule {
        freeformType = format.type;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services."wayvnc" = {
      Unit = {
        Description = "wayvnc VNC server";
        Documentation = ["man:wayvnc(1)"];
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };
      Service.ExecStart = ["${getExe cfg.package}"];
      Install.WantedBy = lib.mkIf cfg.autoStart ["graphical-session.target"];
    };

    xdg.configFile."wayvnc/config".source = format.generate "wayvnc.conf" cfg.settings;
  };
}
