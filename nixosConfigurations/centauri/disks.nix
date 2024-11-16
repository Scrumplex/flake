{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/usb-Generic_STORAGE_DEVICE_000000001206-0:0";
    content = {
      type = "gpt";
      partitions = {
        bl2 = {
          priority = 1;
          start = "34";
          end = "8191";
          alignment = 1;
        };
        fip = {
          priority = 2;
          start = "8192";
          end = "+4M";
          alignment = 1;
        };
        root = {
          size = "100%";
          type = "8304"; # Linux x86-64 root (/)
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
    postCreateHook = ''
      uboot=${pkgs.banana-pi-r4-firmware}

      sgdisk -A 1:set:2 -A 3:set:2 $device
      sgdisk --change-name 1:bl2 --change-name 2:fip $device

      dd if=$uboot/bl2.img of=$device-part1 status=progress
      dd if=$uboot/fip.bin of=$device-part2 status=progress
    '';
  };
}
