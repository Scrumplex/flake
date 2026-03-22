{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs,
  chromium,
}:
buildNpmPackage {
  pname = "netzbremse-measurement";
  version = "0-unstable-2026-01-30";

  src = fetchFromGitHub {
    owner = "AKVorrat";
    repo = "netzbremse-measurement";
    rev = "dfd510eaa9a05cd004a2f0b1062aba5d7e53ec01";
    hash = "sha256-9M1H3TzXTI/9WKaRbAGAV7C5AeLaue41blMNUJE3DGc=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  npmDepsHash = "sha256-rTLArMLmhjHiLjn2wSAF1cJfVAH+LEnZ5GZo1PQ3AkM=";

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/lib/netzbremse-measurement index.js

    cp -r node_modules $out/lib/netzbremse-measurement/node_modules

    makeWrapper ${nodejs}/bin/node $out/bin/netzbremse-measurement \
      --add-flags "$out/lib/netzbremse-measurement" \
      --set PUPPETEER_EXECUTABLE_PATH "${lib.getExe chromium}"

    runHook postInstall
  '';

  meta = {
    description = "Headless measurement tool for the netzbremse.de campaign";
    homepage = "https://github.com/AKVorrat/netzbremse-measurement";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [Scrumplex];
    mainProgram = "netzbremse-measurement";
    platforms = lib.platforms.all;
  };
}
