{
  buildLinux,
  fetchFromGitHub,
  lib,
  ...
} @ args: (buildLinux (args
  // {
    version = "6.12.0-rc7";
    modDirVersion = "6.12.0-rc7";

    src = fetchFromGitHub {
      owner = "K900";
      repo = "linux";
      rev = "46cbdf232ac80bbb65e0bd136d559d7928274829";
      hash = "sha256-fTkUTLFMI0szDkhiGe+1OPCdqs9WPaDhItwzUHRm62o=";
    };

    defconfig = "mt7988a_bpi-r4_defconfig";

    autoModules = false;

    structuredExtraConfig = with lib.kernel; {
      BTRFS_FS = module;
      BTRFS_FS_POSIX_ACL = yes;

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
