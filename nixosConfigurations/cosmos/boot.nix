{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "console=ttyAMA0,115200"
      "console=tty1"
    ];
  };

  #hardware.deviceTree.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
}
