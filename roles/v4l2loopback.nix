{
  config,
  lib,
  ...
}: let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.roles.v4l2loopback;
in {
  options.roles.v4l2loopback = {
    enable = mkEnableOption "v4l2loopback role";
  };

  config = mkIf cfg.enable {
    boot.extraModulePackages = [
      config.boot.kernelPackages.v4l2loopback
    ];
    boot.kernelModules = [
      "v4l2loopback"
    ];
  };
}
