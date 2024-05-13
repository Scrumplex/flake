{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.profile.boot;
in {
  options.profile.boot.quiet = mkEnableOption "quiet boot";

  config = mkIf cfg.quiet {
    boot = {
      initrd.verbose = false;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "udev.log_level=3"];
    };
  };
}
