{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs) srvos nixos-hardware;
in {
  imports = [
    "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
    srvos.nixosModules.server
    nixos-hardware.nixosModules.raspberry-pi-3
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  age.secrets."Beehive.psk".file = ../../secrets/common/Beehive.psk.age;

  nixpkgs.hostPlatform = "aarch64-linux";

  sdImage = {
    # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low on space.
    compressImage = false;
    imageName = "zero2.img";
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    firmware = [pkgs.raspberrypiWirelessFirmware];
    i2c.enable = true;
    deviceTree.filter = "bcm2837-rpi-zero*.dtb";
    deviceTree.overlays = [
      {
        name = "enable-i2c";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          / {
            compatible = "brcm,bcm2837";
            fragment@0 {
              target = <&i2c1>;
              __overlay__ {
                status = "okay";
              };
            };
          };
        '';
      }
    ];
  };

  boot.initrd.supportedFilesystems.zfs = false;
  boot.supportedFilesystems.zfs = false;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Workaround for https://forums.raspberrypi.com/viewtopic.php?t=366155
  boot.kernelParams = ["brcmfmac.feature_disable=0x82000"];

  #facter.reportPath = ./facter.json;

  systemd.tmpfiles.settings."10-iwd"."/var/lib/iwd/Beehive.psk"."L" = {
    mode = "0600";
    argument = config.age.secrets."Beehive.psk".path;
  };

  networking = {
    wireless.iwd.enable = true;
    domain = "lan";
    interfaces.wlan0.useDHCP = true;
  };

  system.stateVersion = "25.05";
}
