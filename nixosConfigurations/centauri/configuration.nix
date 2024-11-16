{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  crossPkgs = import inputs.nixpkgs {
    localSystem = lib.systems.elaborate "x86_64-linux";
    crossSystem = lib.systems.elaborate "aarch64-linux";
    overlays = [
      inputs.self.overlays.default
    ];
  };
in {
  imports = [
    inputs.srvos.nixosModules.server
  ];

  nixpkgs.overlays = [inputs.self.overlays.default];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelParams = [
    "console=ttyS0,115200n8"
    "earlycon=uart8250,mmio32,0x11000000"
    "pci=pcie_bus_perf"
    "pstore_blk.blkdev=/dev/nvme0n1p2"
    "pstore_blk.kmsg_size=128"
    "best_effort=y"
  ];

  boot.initrd.includeDefaultModules = false;
  # We don't need all the default firmware. Just linux-firmware is enough
  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [pkgs.linux-firmware];
  boot.kernelPackages = crossPkgs.linuxPackagesFor crossPkgs.linux-bpir4;
  hardware.deviceTree.name = "mediatek/mt7988a-bananapi-bpi-r4.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "mt7988a-bananapi-bpi-r4-sd.dtso";
      dtsFile = "${config.boot.kernelPackages.kernel.src}/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-sd.dtso";
    }
    {
      name = "mt7988a-bananapi-bpi-r4-rtc.dtso";
      dtsFile = "${config.boot.kernelPackages.kernel.src}/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-rtc.dtso";
    }
    {
      name = "mt7988a-bananapi-bpi-r4-wifi-mt7996a.dtso";
      dtsFile = "${config.boot.kernelPackages.kernel.src}/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-wifi-mt7996a.dtso";
    }
  ];

  networking.hostName = "centauri";

  networking.useDHCP = false;
  networking.interfaces."lan1".useDHCP = true;

  systemd.tpm2.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  nixpkgs.hostPlatform.system = "aarch64-linux";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  system.build = {
    sdImage = import "${inputs.nixpkgs}/nixos/lib/make-disk-image.nix" {
      name = "bpi-r4-sd-image";
      copyChannel = false;
      partitionTableType = "none";
      inherit config lib pkgs;
    };
    uboot = pkgs.runCommand "uboot.img" {} ''
      dd if=${pkgs.banana-pi-r4-firmware}/bl2.img of=uboot.img
      # magic offset hardcoded in BL2 by default
      dd if=${pkgs.banana-pi-r4-firmware}/fip.bin of=uboot.img conv=notrunc bs=512 seek=$((0x580000 / 512))

      mkdir $out
      mv uboot.img $out/
    '';
  };

  system.stateVersion = "24.11";
}
