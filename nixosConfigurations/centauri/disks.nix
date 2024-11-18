{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.centauri = {
    type = "disk";
    device = "/dev/disk/by-id/usb-Generic_STORAGE_DEVICE_000000001206-0:0";
    content = {
      type = "gpt";
      partitions = {
        bl2 = {
          type = "b000"; # U-Boot boot loader
          label = "bl2";
          priority = 1;
          start = "34";
          end = "8191";
          alignment = 1;
        };
        u-boot-env = {
          type = "3DE21764-95BD-54BD-A5C3-4ABE786F38A8"; # U-Boot environment
          label = "u-boot-env";
          priority = 2;
          start = "8192";
          end = "9215";
          alignment = 1;
        };
        factory = {
          type = "8300";
          label = "factory";
          priority = 3;
          start = "9216";
          end = "13311";
          alignment = 1;
        };
        fip = {
          type = "8300";
          label = "fip";
          priority = 4;
          start = "13312";
          end = "17407";
          alignment = 1;
        };
        root = {
          size = "100%";
          type = "8305"; # Linux aarch64 root (/)
          start = "17408";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = ["noatime"];
          };
        };
      };
    };
    postCreateHook = ''
      sgdisk \
        -A 1:set:2 \
        -A 5:set:2 \
        "$device"

      dd conv=notrunc if=${pkgs.banana-pi-r4-firmware}/bl2.img of=$device bs=512 seek=${config.disko.devices.disk.centauri.content.partitions.bl2.start}
      dd conv=notrunc if=${pkgs.banana-pi-r4-firmware}/fip.bin of=$device bs=512 seek=${config.disko.devices.disk.centauri.content.partitions.fip.start}
      dd conv=notrunc if=${config.system.build.rootfsExt4Image} of=$device bs=$((512 * 16)) seek=$((${config.disko.devices.disk.centauri.content.partitions.root.start} / 16))
      e2fsck -f ${config.disko.devices.disk.centauri.content.partitions.root.device}
      resize2fs -f ${config.disko.devices.disk.centauri.content.partitions.root.device}
    '';
  };

  system.build.rootfsExt4Image = pkgs.callPackage (pkgs.path + "/nixos/lib/make-ext4-fs.nix") {
    storePaths = config.system.build.toplevel;
    compressImage = false;
    volumeLabel = "disk-main-root";
    populateImageCommands = ''
      mkdir ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
  };
}
