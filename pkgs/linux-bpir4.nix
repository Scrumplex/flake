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
    rev = "fd7b607fcc673865baf2c29f22735407d6f4f7d7";
    hash = "sha256-U0KZBZTTsa13+BmdkU0G3OZFSUKWpDKBZBkl15D1pAQ=";
  };

  configfile = "${src}/arch/arm64/configs/mt7988a_bpi-r4_defconfig";
  allowImportFromDerivation = true;
}
