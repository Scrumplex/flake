{
  lib,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "zoom65-udev-rules";
  version = "20230210";

  src = [./zoom65.rules];

  dontUnpack = true;

  installPhase = ''
    install -Dpm644 $src $out/lib/udev/rules.d/70-zoom65.rules
  '';

  meta = with lib; {
    homepage = "https://wooting.helpscoutdocs.com/article/34-linux-udev-rules";
    description = "udev rules that give NixOS permission to communicate with Zoom65";
    platforms = platforms.linux;
    license = licenses.cc0;
    maintainers = with maintainers; [Scrumplex];
  };
}
