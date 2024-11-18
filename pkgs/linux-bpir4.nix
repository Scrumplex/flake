{
  buildLinux,
  fetchFromGitHub,
  lib,
  ...
} @ args: (buildLinux (args
  // {
    version = "6.12";
    modDirVersion = "6.12.0";

    src = fetchFromGitHub {
      owner = "K900";
      repo = "linux";
      rev = "b9810763c25c72e1ffc8a676e3436c1576a95059";
      hash = "sha256-YY4fve8hpJoxciroOjfCgFvVsw4H8HbSXCGrhseqzNY=";
    };

    defconfig = "mt7988a_bpi-r4_defconfig";

    autoModules = false;

    structuredExtraConfig = with lib.kernel; {
      AUTOFS_FS = module;

      # Used by system.etc.overlay.enable as part of a perl-less build.
      EROFS_FS = module;
      EROFS_FS_ZIP_LZMA = yes;
      EROFS_FS_ZIP_DEFLATE = yes;
      EROFS_FS_ZIP_ZSTD = yes;
      EROFS_FS_PCPU_KTHREAD = yes;

      # Disable extremely unlikely features to reduce build storage requirements and time.
      FB = lib.mkForce no;
      DRM = lib.mkForce no;
      SOUND = no;
      INFINIBAND = lib.mkForce no;

      NETFILTER_NETLINK_LOG = module;

      NF_CONNTRACK_BRIDGE = module;
      BRIDGE_NETFILTER = module;
      NFT_BRIDGE_META = module;
      NFT_BRIDGE_REJECT = module;
      NETFILTER_FAMILY_BRIDGE = yes;

      MT7921_COMMON = module;
      MT7921E = module;
      MT7996E = module;
      NFT_LOG = module;
    };

    extraMeta.branch = "bpi-r4";
  }))
