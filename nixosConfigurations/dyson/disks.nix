{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-WD_BLACK_SN750_SE_NVMe_1TB_2138AS441007";
    content = {
      type = "gpt";
      partitions = {
        esp = {
          size = "512M";
          type = "EF00"; # EFI system partition
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["defaults" "umask=0077" "dmask=0077" "fmask=0077"];
          };
        };
        cryptroot = {
          size = "100%";
          type = "8304"; # Linux x86-64 root (/)
          content = {
            type = "luks";
            name = "cryptroot";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
}
