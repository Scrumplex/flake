{
  linuxManualConfig,
  fetchFromGitHub,
  ...
}:
linuxManualConfig rec {
  version = "6.12";
  modDirVersion = "6.12.0";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "b9810763c25c72e1ffc8a676e3436c1576a95059";
    hash = "sha256-YY4fve8hpJoxciroOjfCgFvVsw4H8HbSXCGrhseqzNY=";
  };

  configfile = "${src}/arch/arm64/configs/mt7988a_bpi-r4_defconfig";
  allowImportFromDerivation = true;
}
