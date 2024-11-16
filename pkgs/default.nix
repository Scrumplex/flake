{...}: {
  perSystem = {
    config,
    pkgs,
    ...
  }: {
    packages = {
      logviewer = pkgs.python311.pkgs.callPackage ./logviewer {};

      linux-bpir4 = pkgs.callPackage ./linux-bpir4.nix {};
      uboot-bpir4 = pkgs.callPackage ./uboot-bpir4.nix {};
      banana-pi-r4-firmware = pkgs.callPackage ./banana-pi-r4-firmware.nix {
        uboot = config.packages.uboot-bpir4;
      };
    };
  };
  flake.overlays.default = final: prev: {
    logviewer = final.python311.pkgs.callPackage ./logviewer {};

    linux-bpir4 = final.callPackage ./linux-bpir4.nix {};
    uboot-bpir4 = final.callPackage ./uboot-bpir4.nix {};
    banana-pi-r4-firmware = final.callPackage ./banana-pi-r4-firmware.nix {
      uboot = final.uboot-bpir4;
    };
  };
}
