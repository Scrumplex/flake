{pkgs, ...}: {
  programs.mtr.enable = true;
  programs.bandwhich.enable = true;

  environment.systemPackages = with pkgs; [
    dig
    lsof
    nload
    tree

    pciutils
    psmisc
    usbutils

    p7zip
    unzip

    man-pages

    vimv-rs
  ];
}
