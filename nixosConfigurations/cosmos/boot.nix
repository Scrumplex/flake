{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {
      raspberrypiWirelessFirmware = prev.raspberrypiWirelessFirmware.overrideAttrs {
        version = "0-unstable-2025-04-08";

        srcs = [
          (final.fetchFromGitHub {
            name = "bluez-firmware";
            owner = "RPi-Distro";
            repo = "bluez-firmware";
            rev = "2bbfb8438e824f5f61dae3f6ebb367a6129a4d63";
            hash = "sha256-t+D4VUfEIov83KV4wiKp6TqXTHXGkxg/mANi4GW7QHs=";
          })
          (final.fetchFromGitHub {
            name = "firmware-nonfree";
            owner = "RPi-Distro";
            repo = "firmware-nonfree";
            rev = "c9d3ae6584ab79d19a4f94ccf701e888f9f87a53";
            hash = "sha256-5ywIPs3lpmqVOVP3B75H577fYkkucDqB7htY2U1DW8U=";
          })
        ];
      };
    })
  ];
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "console=ttyAMA0,115200"
      "console=tty1"
    ];
  };

  #hardware.deviceTree.enable = true;
  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;
}
