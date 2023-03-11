self: super:
with self; {
  fishPlugins = super.fishPlugins.overrideScope' (import ./shells/fish/plugins);

  fuzzel-dmenu-shim = callPackage ./tools/wayland/fuzzel-dmenu-shim {};

  listenbrainz-mpd = super.listenbrainz-mpd.overrideAttrs (import ./applications/audio/listenbrainz-mpd);

  qt6ct = qt6Packages.callPackage ./tools/misc/qt6ct {};

  run-or-raise = callPackage ./tools/wayland/run-or-raise {};

  termapp = callPackage ./tools/wayland/termapp {};

  zoom65-udev-rules =
    callPackage ./os-specific/linux/zoom65-udev-rules {};
}
