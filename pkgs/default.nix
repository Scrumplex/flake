self: super:
with self; {
  discord = super.discord.override {
    withOpenASAR = true;
  };

  fishPlugins = super.fishPlugins.overrideScope' (import ./shells/fish/plugins);

  fuzzel-dmenu-shim = callPackage ./tools/wayland/fuzzel-dmenu-shim {};

  glfw-wayland-minecraft = callPackage ./development/libraries/glfw-wayland-minecraft {};

  glfwUnstable = super.glfw.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "glfw";
      repo = "GLFW";
      rev = "62e175ef9fae75335575964c845a302447c012c7";
      sha256 = "sha256-GiY4d7xadR0vN5uCQyWaOpoo2o6uMGl1fCcX4uDGnks=";
    };
  });

  linux_zen_scrumplex = linuxPackagesFor (super.linuxKernel.packages.linux_zen.kernel.override {
    kernelPatches = [
      {
        name = "cap_sys_nice_begone";
        patch = ./cap_sys_nice_begone.patch;
      }
    ];
  });

  ncmpcpp = super.ncmpcpp.override {
    visualizerSupport = true;
  };

  prismlauncher = super.prismlauncher.override {
    glfw = glfwUnstable;
  };

  qt6ct = qt6Packages.callPackage ./tools/misc/qt6ct {};

  run-or-raise = callPackage ./tools/wayland/run-or-raise {};

  termapp = callPackage ./tools/wayland/termapp {};

  zoom65-udev-rules =
    callPackage ./os-specific/linux/zoom65-udev-rules {};
}
