{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.deck = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-KINGSTON_OM3PDP3256B-A01_50026B76854586D9";
    content = {
      type = "gpt";
      partitions = {
        esp = {
          size = "1G";
          type = "EF00"; # EFI system partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["defaults" "umask=0077" "dmask=0077" "fmask=0077"];
          };
        };
        root = {
          end = "-8G";
          type = "8304"; # Linux x86-64 root (/)
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
        swap = {
          size = "100%";
          type = "8200"; # Linux swap
          content = {
            type = "swap";
            discardPolicy = "both";
            resumeDevice = true;
          };
        };
      };
    };
  };
}
