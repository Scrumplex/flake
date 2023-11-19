{pkgs, ...}: {
  programs.mtr.enable = true;
  programs.bandwhich.enable = true;

  environment.systemPackages = with pkgs; [
    nload

    pciutils
    usbutils
  ];
}
