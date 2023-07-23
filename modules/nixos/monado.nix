{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkPackageOption;

  cfg = config.services.monado;
in {
  options.services.monado = {
    enable = mkEnableOption "monado";

    package = mkPackageOption pkgs "monado" {};
  };

  config = mkIf cfg.enable {
    security.wrappers."monado-service" = {
      owner = "root";
      group = "root";
      # cap_sys_nice needed for asynchronous reprojection
      capabilities = "cap_sys_nice+eip";
      source = "${cfg.package}/bin/monado-service";
    };

    systemd.user = {
      services.monado = {
        description = "Monado XR runtime service module";
        requires = ["monado.socket"];
        conflicts = ["monado-dev.service"];

        unitConfig.ConditionUser = "!root";

        environment = {
          XRT_COMPOSITOR_LOG = "debug";
          XRT_PRINT_OPTIONS = "on";
          IPC_EXIT_ON_DISCONNECT = "off";
        };

        serviceConfig = {
          ExecStart = "${config.security.wrapperDir}/monado-service";
          Restart = "no";
        };

        restartTriggers = [cfg.package];
      };

      sockets.monado = {
        description = "Monado XR service module connection socket";
        conflicts = ["monado-dev.service"];

        unitConfig.ConditionUser = "!root";

        socketConfig = {
          ListenStream = "%t/monado_comp_ipc";
          RemoveOnStop = true;
        };

        restartTriggers = [cfg.package];

        wantedBy = ["sockets.target"];
      };
    };

    environment.systemPackages = [cfg.package];
  };
}
