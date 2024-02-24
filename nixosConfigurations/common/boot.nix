{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    tmp = {
      useTmpfs = lib.mkDefault true;
      tmpfsSize = "75%";
    };
    initrd.verbose = false;
    initrd.systemd.enable = true;
    consoleLogLevel = 0;
    kernelParams = ["quiet" "udev.log_level=3"];

    kernel.sysctl."kernel.sysrq" = 1;
  };
}
