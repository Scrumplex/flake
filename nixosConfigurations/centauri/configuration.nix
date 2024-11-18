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

  boot.postBootCommands = ''
    # On the first boot do some maintenance tasks
    if [ -f "/nix-path-registration" ]; then
      set -euo pipefail
      set -x

      # Register the contents of the initial Nix store
      ${config.nix.package.out}/bin/nix-store --load-db < "/nix-path-registration"

      # nixos-rebuild also requires a "system" profile and an /etc/NIXOS tag.
      touch /etc/NIXOS
      ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/system --set /run/current-system

      # Prevents this from running on later boots.
      rm -f "/nix-path-registration"
    fi
  '';

  system.stateVersion = "24.11";
}
