{
  lib,
  stdenv,
  fuzzel,
}:
stdenv.mkDerivation rec {
  pname = "fuzzel-dmenu-shim";
  version = "20230219";

  src = [./fuzzel-menu.sh];

  dontUnpack = true;

  buildInputs = [fuzzel];

  installPhase = ''
    install -Dpm755 $src $out/bin/fuzzel-menu
    ln -sf fuzzel-menu $out/bin/dmenu
    ln -sf fuzzel-menu $out/bin/dmenu-wl
    ln -sf fuzzel-menu $out/bin/bemenu
  '';

  postFixup = let
    runtimePath = lib.makeBinPath buildInputs;
  in ''
    sed -i "2 i export PATH=${runtimePath}:\$PATH" $out/bin/fuzzel-menu
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/Scrumplex/dotfiles";
    description = "A shim that makes it possible to use fuzzel for any dmenu script.";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [Scrumplex];
  };
}
