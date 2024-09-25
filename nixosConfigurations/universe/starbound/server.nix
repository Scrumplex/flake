{
  autoPatchelfHook,
  lib,
  patchelf,
  requireFile,
  stdenv,
}:
stdenv.mkDerivation {
  name = "starbound-dedicated-server";
  version = "1.4.3";
  src = requireFile {
    name = "Starbound.tar";
    hash = "sha256-tdU0WU+p8GQ2GK00beCX9B4JSNM3ljWv4uC4wjbasO4=";
    message = ''
      Install Starbound Dedicated Server on Linux using Steam and run the following command in your `steamapps/common` folder:
        $ tar --mtime='1980-01-01 00:00Z' -cf Starbound.tar "Starbound Dedicated Server"
        $ nix-prefetch-url file://\$PWD/Starbound.tar
        <hash>
        $ nix hash to-sri --type sha256 <hash>
    '';
  };

  nativeBuildInputs = [autoPatchelfHook patchelf];

  buildInputs = [stdenv.cc.cc.lib];

  # Skip phases that don't apply to prebuilt binaries.
  dontBuild = true;
  dontConfigure = true;

  postPatch = ''
    substituteInPlace linux/sbinit.config \
      --replace-fail "../assets/" "$out/share/starbound/" \
      --replace-fail "../mods/" "mods/" \
      --replace-fail "../storage/" "storage/" \
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 linux/starbound_server $out/bin/starbound-server
    install -Dm755 linux/libsteam_api.so $out/lib/libsteam_api.so
    install -Dm644 -t $out/share/starbound assets/packed.pak linux/sbinit.config
    patchelf $out/bin/starbound-server \
      --add-needed "libsteam_api.so"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Starbound Dedicated Server";
    homepage = "https://steamdb.info/app/533830/";
    changelog = "https://store.steampowered.com/news/app/211820?updates=true";
    sourceProvenance = with sourceTypes; [
      binaryNativeCode
    ];
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    mainProgram = "starbound-server";
  };
}
