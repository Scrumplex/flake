{
  fetchFromGitHub,
  buildUBoot,
}:
buildUBoot {
  version = "2024.10-mtk";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "u-boot";
    rev = "7ae5ffe139d5fe466e087d3238ca1fd77d02b632";
    hash = "sha256-1p/jmduLRv76TyVswfY0+yEebm9ugEfguvvAkvdnh88=";
  };

  defconfig = "mt7988a_bananapi_bpi-r4-bootstd_defconfig";
  filesToInstall = ["u-boot.bin"];

  extraMeta.branch = "bpi-r4";
}
