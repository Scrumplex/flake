{
  lib,
  stdenv,
  coreutils,
  kitty,
  run-or-raise,
}:
stdenv.mkDerivation rec {
  pname = "termapp";
  version = "20230210";

  src = [./termapp.sh];

  dontUnpack = true;

  buildInputs = [coreutils kitty run-or-raise];

  installPhase = ''
    install -Dpm755 $src $out/bin/termapp
  '';

  postFixup = let
    runtimePath = lib.makeBinPath buildInputs;
  in ''
    sed -i "2 i export PATH=${runtimePath}:\$PATH" $out/bin/termapp
  '';

  meta = with lib; {
    homepage = "https://codeberg.org/Scrumplex/dotfiles";
    description = "A utility to run terminal apps using run-or-raise";
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [Scrumplex];
  };
}
