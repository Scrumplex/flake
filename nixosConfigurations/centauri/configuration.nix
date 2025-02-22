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
  ];

  boot.initrd.includeDefaultModules = false;
  # We don't need all the default firmware. Just linux-firmware is enough
  hardware.enableRedistributableFirmware = false;
  hardware.firmware = [pkgs.linux-firmware];
  boot.kernelPackages = crossPkgs.linuxPackagesFor crossPkgs.linux-bpir4;

  #hardware.deviceTree.name = "mediatek/mt7988a-bananapi-bpi-r4.dtb";
  hardware.deviceTree.overlays = [
    {
      name = "mt7988a-bananapi-bpi-r4-sd.dtso";
      dtsFile = "${config.boot.kernelPackages.kernel.src}/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-sd.dtso";
    }
    {
      name = "bpi-r4-wireless";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "bananapi,bpi-r4";
        };

        &{/} {
          wifi_12v: regulator-wifi-12v {
            compatible = "regulator-fixed";
            regulator-name = "wifi";
            regulator-min-microvolt = <12000000>;
            regulator-max-microvolt = <12000000>;
            gpio = <&pio 4 0>; // GPIO_ACTIVE_HIGH = 0
            enable-active-high;
            regulator-always-on;
          };
        };

        &i2c_wifi {
          status = "okay";

          // 5G WIFI MAC Address EEPROM
          wifi_eeprom@51 {
            compatible = "atmel,24c02";
            reg = <0x51>;
            address-bits = <8>;
            page-size = <8>;
            size = <256>;

            nvmem-layout {
              compatible = "fixed-layout";
              #address-cells = <1>;
              #size-cells = <1>;

              macaddr_5g: macaddr@0 {
                  reg = <0x0 0x6>;
              };
            };
          };

          // 6G WIFI MAC Address EEPROM
          wifi_eeprom@52 {
            compatible = "atmel,24c02";
            reg = <0x52>;
            address-bits = <8>;
            page-size = <8>;
            size = <256>;

            nvmem-layout {
              compatible = "fixed-layout";
              #address-cells = <1>;
              #size-cells = <1>;

              macaddr_6g: macaddr@0 {
                  reg = <0x0 0x6>;
              };
            };
          };
        };

        &pcie0 {
          pcie@0,0 {
            reg = <0x0000 0 0 0 0>;

            wifi@0,0 {
              compatible = "mediatek,mt76";
              reg = <0x0000 0 0 0 0>;
              nvmem-cell-names = "mac-address";
              nvmem-cells = <&macaddr_5g>;
            };
          };
        };

        &pcie1 {
          pcie@0,0 {
            reg = <0x0000 0 0 0 0>;

            wifi@0,0 {
              compatible = "mediatek,mt76";
              reg = <0x0000 0 0 0 0>;
              nvmem-cell-names = "mac-address";
              nvmem-cells = <&macaddr_6g>;
            };
          };
        };
      '';
    }
  ];

  networking.hostName = "centauri";

  networking.useDHCP = false;
  networking.interfaces."lan1".useDHCP = true;

  networking.wireless.enable = true;

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
