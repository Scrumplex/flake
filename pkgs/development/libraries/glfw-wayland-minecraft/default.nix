{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  libGL,
  extra-cmake-modules,
  wayland,
  wayland-protocols,
  libxkbcommon,
}:
stdenv.mkDerivation {
  version = "unstable-2022-05-06";
  pname = "glfw-wayland-minecraft";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    rev = "62e175ef9fae75335575964c845a302447c012c7";
    sha256 = "sha256-GiY4d7xadR0vN5uCQyWaOpoo2o6uMGl1fCcX4uDGnks=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/15f88a515c63a9716cfdf4090fab8e16543f4ebd/0003-Don-t-crash-on-calls-to-focus-or-icon.patch";
      hash = "sha256-NZbKh16h+tWXXnz13QcFBFaeGXMNxZKGQb9xJEahFnE=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/15f88a515c63a9716cfdf4090fab8e16543f4ebd/0004-wayland-fix-broken-opengl-screenshots-on-mutter.patch";
      hash = "sha256-EjjaaEgi7JZQ5a5l/Ng/7RSdQrTNwdENSiJCsFP9imU=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/15f88a515c63a9716cfdf4090fab8e16543f4ebd/0005-Add-warning-about-being-an-unofficial-patch.patch";
      hash = "sha256-QMUNlnlCeFz5gIVdbM+YXPsrmiOl9cMwuVRSOvlw+T0=";
    })
    (fetchpatch2 {
      url = "https://raw.githubusercontent.com/Admicos/minecraft-wayland/bdc3c0d192097459eb4e72b26c8267f82266e951/0007-Platform-Prefer-Wayland-over-X11.patch";
      hash = "sha256-dqEOfj9NRuPtOfe4YS2s5dqW/xx3SXFmMm3bf+f/TgQ=";
    })
  ];

  propagatedBuildInputs = [libGL];

  nativeBuildInputs = [cmake extra-cmake-modules];

  buildInputs = [wayland wayland-protocols libxkbcommon];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DGLFW_BUILD_WAYLAND=ON"
    "-DGLFW_BUILD_X11=OFF"
    "-DCMAKE_C_FLAGS=-D_GLFW_EGL_LIBRARY='\"${lib.getLib libGL}/lib/libEGL.so.1\"'"
  ];

  postPatch = ''
    substituteInPlace src/wl_init.c \
      --replace "libxkbcommon.so.0" "${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"
  '';

  meta = with lib; {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time - with patches to support Minecraft on Wayland";
    homepage = "https://www.glfw.org/";
    license = licenses.zlib;
    maintainers = with maintainers; [Scrumplex];
    platforms = platforms.linux;
  };
}
