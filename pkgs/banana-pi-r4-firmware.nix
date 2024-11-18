{
  buildArmTrustedFirmware,
  dtc,
  fetchFromGitHub,
  openssl,
  uboot,
  ubootTools,
  which,
}:
buildArmTrustedFirmware {
  src = fetchFromGitHub {
    owner = "mtk-openwrt";
    repo = "arm-trusted-firmware";
    rev = "bacca82a8cac369470df052a9d801a0ceb9b74ca";
    hash = "sha256-n5D3styntdoKpVH+vpAfDkCciRJjCZf9ivrI9eEdyqw=";
  };

  nativeBuildInputs = [
    dtc
    openssl
    ubootTools
    which
  ];

  platform = "mt7988";

  extraMakeFlags = [
    "BL33=${uboot}/u-boot.bin" # FIP-ify our uboot
    "BOOT_DEVICE=sdmmc" # boot from SD card
    "DRAM_USE_COMB=1" # you're supposed to use this one, sayeth mediatek
    "DDR4_4BG_MODE=0" # disable large RAM support, for some reason this breaks things
    "USE_MKIMAGE=1" # use uboot mkimage instead of vendor mtk tool
    "bl2"
    "fip"
  ];

  filesToInstall = [
    "build/mt7988/release/bl2.img"
    "build/mt7988/release/fip.bin"
  ];
}
