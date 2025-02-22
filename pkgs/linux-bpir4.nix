{
  linuxManualConfig,
  fetchFromGitHub,
  ...
}:
linuxManualConfig rec {
  version = "6.14.0-rc3";
  modDirVersion = "6.14.0-rc3";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "62cb3d53150559ac3e1e06558f39ab4e80a0c376";
    hash = "sha256-h2vDic+MhqD89fWa0NWwlr6IdG2IuOje4j2HRtJ7ZAc=";
  };

  configfile = "${src}/arch/arm64/configs/mt7988a_bpi-r4_defconfig";
  allowImportFromDerivation = true;
}
