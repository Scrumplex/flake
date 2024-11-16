{
  fetchFromGitHub,
  buildUBoot,
}:
buildUBoot {
  version = "2024.10-mtk";

  src = fetchFromGitHub {
    owner = "K900";
    repo = "u-boot";
    rev = "32ef47da794d49c812cbb1f0a1b8b94df4e4bb19";
    hash = "sha256-xXkY1RkQLCUZ8BP3A/GwFdAwKqvz7YEIpP8iQnIZMZc=";
  };

  defconfig = "mt7988a_bananapi_bpi-r4-bootstd_defconfig";
  filesToInstall = ["u-boot.bin"];

  extraMeta.branch = "bpi-r4";
}
