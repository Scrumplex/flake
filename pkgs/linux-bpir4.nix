{
  linuxManualConfig,
  fetchFromGitHub,
  ...
}:
linuxManualConfig rec {
  version = "6.12.1";
  modDirVersion = "6.12.1";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "5e59ce1897fb2fc3886d8ae14f23f8857632ccfd";
    hash = "sha256-s403wWAGyONsrVPLuCjLAr+30RfKqLqzJs6Y4F7VzR0=";
  };

  configfile = "${src}/arch/arm64/configs/mt7988a_bpi-r4_defconfig";
  allowImportFromDerivation = true;
}
