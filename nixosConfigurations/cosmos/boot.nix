{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "console=ttyAMA0,115200"
      "console=tty1"
    ];
  };
}
