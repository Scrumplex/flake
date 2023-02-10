{ lib, config, pkgs, ... }:

{
  run-or-raise = pkgs.callPackage ./tools/wayland/run-or-raise { };

  termapp = pkgs.callPackage ./tools/wayland/termapp { };

  zoom65-udev-rules =
    pkgs.callPackage ./os-specific/linux/zoom65-udev-rules { };
}
