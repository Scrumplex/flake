{pkgs, ...}: {
  programs.mtr.enable = true;
  programs.bandwhich.enable = true;

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
  ];
}
