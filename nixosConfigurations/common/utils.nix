{pkgs, ...}: {
  programs.mtr.enable = true;
  programs.bandwhich.enable = true;

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  environment.systemPackages = with pkgs; [
    dig
    ffmpeg
    flatpak-builder
    nload

    pciutils
    psmisc
    usbutils

    p7zip
    unzip

    man-pages
  ];
}
