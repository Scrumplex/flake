{lib, ...}: let
  inherit (lib.modules) mkDefault;
in {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    tmp = {
      useTmpfs = mkDefault true;
      tmpfsSize = "75%";
    };
    initrd.verbose = false;
    initrd.systemd.enable = true;
    consoleLogLevel = 0;
    kernelParams = ["quiet" "udev.log_level=3"];
  };
}
