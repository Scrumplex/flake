pkgs:
with pkgs; {
  discord =
    (import ../applications/networking/instant-messengers/discord {
      inherit lib stdenv;
      inherit callPackage fetchurl;
      branch = "stable";
    })
    .override {
      withOpenASAR = true;
      withVencord = true;
    };

  fuzzel-dmenu-shim = callPackage ../tools/wayland/fuzzel-dmenu-shim {};

  glfw-wayland-minecraft = callPackage ../development/libraries/glfw-wayland-minecraft {};

  kernelPatches.cap_sys_nice_begone = {
    name = "cap_sys_nice_begone";
    patch = ../cap_sys_nice_begone.patch;
  };

  qt6ct = qt6Packages.callPackage ../tools/misc/qt6ct {};

  run-or-raise = callPackage ../tools/wayland/run-or-raise {};

  termapp = callPackage ../tools/wayland/termapp {};

  vencord = callPackage ../development/misc/vencord {};

  zoom65-udev-rules =
    callPackage ../os-specific/linux/zoom65-udev-rules {};
}
