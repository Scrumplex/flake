{
  linuxManualConfig,
  fetchFromGitHub,
  ...
}:
linuxManualConfig rec {
  version = "6.14.0-rc6";
  modDirVersion = "6.14.0-rc6";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "linux";
    rev = "dd32ac8233abeb2708dbe849ac325f76419228a4";
    hash = "sha256-TkEIgQKUQc0M/B7fhYUU7tXVqUNFtnUPZ+2ZkWHkZOc=";
  };

  configfile = "${src}/arch/arm64/configs/mt7988a_bpi-r4_defconfig";
  allowImportFromDerivation = true;
}
