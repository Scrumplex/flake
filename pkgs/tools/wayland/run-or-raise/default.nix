{
  lib,
  stdenv,
  sway,
}:
stdenv.mkDerivation rec {
  pname = "run-or-raise";
  version = "20230210";

  src = [./run-or-raise.sh];

  dontUnpack = true;

  buildInputs = [sway];

  installPhase = ''
    install -Dpm755 $src $out/bin/run-or-raise
  '';

  postFixup = let
    runtimePath = lib.makeBinPath buildInputs;
  in ''
    sed -i "2 i export PATH=${runtimePath}:\$PATH" $out/bin/run-or-raise
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/Scrumplex/dotfiles";
    description = "A run-or-raise application switcher for Sway";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [Scrumplex];
  };
}
