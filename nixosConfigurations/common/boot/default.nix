{inputs, ...}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernel.sysctl."kernel.sysrq" = 1;

    consoleLogLevel = 0;
    kernelParams = ["quiet" "udev.log_level=3"];
  };
}
