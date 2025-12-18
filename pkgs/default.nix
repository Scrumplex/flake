{...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      channel-notifier = pkgs.python3.pkgs.callPackage ./channel-notifier {};

      ha-solarman = pkgs.home-assistant.python.pkgs.callPackage ./ha-solarman.nix {};

      linux-bpir4 = pkgs.callPackage ./linux-bpir4.nix {};
      uboot-bpir4 = pkgs.callPackage ./uboot-bpir4.nix {};
      banana-pi-r4-firmware = pkgs.callPackage ./banana-pi-r4-firmware.nix {
        uboot = config.packages.uboot-bpir4;
      };
    };
  };
  flake.overlays.default = final: _: {
    channel-notifier = final.python3.pkgs.callPackage ./channel-notifier {};

    ha-solarman = final.home-assistant.python.pkgs.callPackage ./ha-solarman.nix {};

    linux-bpir4 = final.callPackage ./linux-bpir4.nix {};
    uboot-bpir4 = final.callPackage ./uboot-bpir4.nix {};
    banana-pi-r4-firmware = final.callPackage ./banana-pi-r4-firmware.nix {
      uboot = final.uboot-bpir4;
    };
  };
}
