{
  lib,
  stdenv,
  fetchFromGitHub,
  qtbase,
  qtsvg,
  qmake,
  qttools,
}: let
  inherit (lib) getDev;
in
  stdenv.mkDerivation rec {
    pname = "qt6ct";
    version = "0.7";

    src = fetchFromGitHub {
      owner = "trialuser02";
      repo = "qt6ct";
      rev = version;
      sha256 = "7WuHdb7gmdC/YqrPDT7OYbD6BEm++EcIkmORW7cSPDE=";
    };

    nativeBuildInputs = [qmake qttools];

    buildInputs = [qtbase qtsvg];

    qmakeFlags = [
      "LRELEASE_EXECUTABLE=${getDev qttools}/bin/lrelease"
      "PLUGINDIR=${placeholder "out"}/${qtbase.qtPluginPrefix}"
    ];
    dontWrapQtApps = true;

    meta = with lib; {
      description = "Qt6 Configuration Tool";
      homepage = "https://github.com/trialuser02/qt6ct";
      platforms = platforms.linux;
      license = licenses.bsd2;
      maintainers = with maintainers; [Scrumplex];
    };
  }
