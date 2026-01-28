{inputs, ...}: {
  flake.modules.nixos."machine-galileo" = {
    imports = [
      inputs.disko.nixosModules.default
    ];

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SX8200PNP-512GT-S_2K50291457UX";
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
          swap = {
            size = "16G";
            type = "8200"; # EFI system partition
            content = {
              type = "swap";
              discardPolicy = "both";
            };
          };
          nixos = {
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
    };
  };
}
