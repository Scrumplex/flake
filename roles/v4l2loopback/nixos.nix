{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.roles.v4l2loopback;
in {
  config = mkIf cfg.enable {
    boot.extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    boot.kernelModules = [
      "v4l2loopback"
    ];
  };
}
