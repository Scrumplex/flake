{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault mkIf mkMerge;
in {
  boot = mkMerge [
    {
      bootspec.enable = mkDefault true;

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      tmp = {
        useTmpfs = mkDefault true;
        tmpfsSize = "75%";
      };
    }
    (mkIf config.system.role.desktop {
      initrd.verbose = false;
      initrd.systemd.enable = true;
      consoleLogLevel = 0;
      kernelParams = ["quiet" "udev.log_level=3"];
    })
  ];
}
