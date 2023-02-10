{ lib, config, pkgs, ... }:

{
  zoom65-udev-rules =
    pkgs.callPackage ./os-specific/linux/zoom65-udev-rules { };
}
