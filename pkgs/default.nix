{pkgs, ...}: {
  fuzzel-dmenu-shim = pkgs.callPackage ./tools/wayland/fuzzel-dmenu-shim {};

  qt6ct = pkgs.qt6Packages.callPackage ./tools/misc/qt6ct {};

  run-or-raise = pkgs.callPackage ./tools/wayland/run-or-raise {};

  termapp = pkgs.callPackage ./tools/wayland/termapp {};

  zoom65-udev-rules =
    pkgs.callPackage ./os-specific/linux/zoom65-udev-rules {};
}
