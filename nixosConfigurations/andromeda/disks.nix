{inputs, ...}: {
  imports = [
    inputs.disko.nixosModules.default
  ];

  disko.devices.disk = {
    main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S4EWNM0W901136P";
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
    };
    data = {
      type = "disk";
      device = "/dev/disk/by-id/ata-SanDisk_SDSSDH3_2T00_213894440406";
      content = {
        type = "gpt";
        partitions = {
          data = {
            end = "-16G";
            type = "8300"; # Linux filesystem
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/media/DATA";
              mountOptions = ["defaults" "noauto" "x-systemd.automount"];
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
  };
}
