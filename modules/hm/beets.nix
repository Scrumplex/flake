{
  config,
  lib,
  ...
}: let
  inherit (lib) literalExpression types;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf mkMerge;

  cfg = config.programs.beets;

  mpdIntegrationOpts = with types;
    submodule {
      options = {
        enableStats = mkEnableOption "mpdstats plugin and service";
        enableUpdate = mkEnableOption "mpdupdate plugin";
        host = mkOption {
          type = str;
          default = "localhost";
          description = "Host mpdstats will connect to";
          example = "10.0.0.42";
        };
        port = mkOption {
          type = int;
          default = config.services.mpd.network.port;
          description = "Port mpdstats will connect to";
          example = "6600";
        };
      };
    };
in {
  meta.maintainers = [lib.maintainers.Scrumplex];

  options.programs.beets = {
    mpdIntegration = mkOption {
      type = mpdIntegrationOpts;
      description = "Configuration for MusicPD integration";
      example = literalExpression ''
        {
          enable = true;
        }
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.mpdIntegration.enableStats || cfg.mpdIntegration.enableUpdate) {
      programs.beets.settings.mpd = {
        host = cfg.mpdIntegration.host;
        port = cfg.mpdIntegration.port;
      };
    })
    (mkIf cfg.mpdIntegration.enableStats {
      programs.beets.settings.plugins = ["mpdstats"];

      systemd.user.services."beets-mpdstats" = {
        Unit = {
          Description = "Beets MPDStats daemon";
          After = ["mpd.service"];
          Requires = ["mpd.service"];
        };
        Service.ExecStart = "${cfg.package}/bin/beet mpdstats";
      };
    })
    (mkIf cfg.mpdIntegration.enableUpdate {
      programs.beets.settings.plugins = ["mpdupdate"];
    })
  ]);
}
