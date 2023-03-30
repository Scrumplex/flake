{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nload

    pciutils
    usbutils
  ];
}
