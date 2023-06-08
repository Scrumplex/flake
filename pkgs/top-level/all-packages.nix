pkgs:
with pkgs; {
  fuzzel-dmenu-shim = callPackage ../tools/wayland/fuzzel-dmenu-shim {};

  glfw-wayland-minecraft = callPackage ../development/libraries/glfw-wayland-minecraft {};

  glfwUnstable = glfw.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "glfw";
      repo = "GLFW";
      rev = "62e175ef9fae75335575964c845a302447c012c7";
      sha256 = "sha256-GiY4d7xadR0vN5uCQyWaOpoo2o6uMGl1fCcX4uDGnks=";
    };
  });

  kernelPatches.cap_sys_nice_begone = {
    name = "cap_sys_nice_begone";
    patch = ../cap_sys_nice_begone.patch;
  };

  run-or-raise = callPackage ../tools/wayland/run-or-raise {};

  termapp = callPackage ../tools/wayland/termapp {};

  zoom65-udev-rules =
    callPackage ../os-specific/linux/zoom65-udev-rules {};
}
