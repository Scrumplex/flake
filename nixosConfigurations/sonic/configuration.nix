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
    "${nixos-hardware}/raspberry-pi/4/pkgs-overlays.nix"
    inputs.nixos-facter-modules.nixosModules.facter
  ];

  age.secrets."Beehive.psk".file = ../../secrets/common/Beehive.psk.age;

  nixpkgs.hostPlatform = "aarch64-linux";

  sdImage = {
    # bzip2 compression takes loads of time with emulation, skip it. Enable this if you're low on space.
    compressImage = false;
    imageName = "zero2.img";
  };

  hardware.raspberry-pi."4".apply-overlays-dtmerge.enable = true;

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
      {
        name = "imx708";
        dtsText = ''
          /dts-v1/;

          / {
            compatible = "brcm,bcm2837";

            fragment@0 {
              target = <0xffffffff>;

              __overlay__ {
                status = "okay";
              };
            };

            fragment@1 {
              target = <0xffffffff>;
              phandle = <0x07>;

              __overlay__ {
                status = "okay";
                clock-frequency = <0x16e3600>;
              };
            };

            fragment@2 {
              target = <0xffffffff>;

              __overlay__ {
                status = "okay";
              };
            };

            fragment@3 {
              target = <0xffffffff>;
              phandle = <0x08>;

              __overlay__ {
                startup-delay-us = <0x11170>;
                off-on-delay-us = <0x7530>;
                regulator-min-microvolt = <0x2932e0>;
                regulator-max-microvolt = <0x2932e0>;
                phandle = <0x09>;
              };
            };

            fragment@4 {
              target = <0x01>;

              __overlay__ {
                lens-focus = <0x02>;
              };
            };

            fragment@100 {
              target = <0xffffffff>;
              phandle = <0x05>;

              __overlay__ {
                #address-cells = <0x01>;
                #size-cells = <0x00>;
                status = "okay";

                imx708@1a {
                  compatible = "sony,imx708";
                  reg = <0x1a>;
                  status = "okay";
                  clocks = <0xffffffff>;
                  clock-names = "inclk";
                  vana1-supply = <0xffffffff>;
                  vana2-supply = <0xffffffff>;
                  vdig-supply = <0xffffffff>;
                  vddl-supply = <0xffffffff>;
                  rotation = <0xb4>;
                  orientation = <0x02>;
                  phandle = <0x01>;

                  port {

                    endpoint {
                      clock-lanes = <0x00>;
                      data-lanes = <0x01 0x02>;
                      clock-noncontinuous;
                      link-frequencies = <0x00 0x1ad27480>;
                      remote-endpoint = <0x03>;
                      phandle = <0x04>;
                    };
                  };
                };

                dw9817@c {
                  compatible = "dongwoon,dw9817-vcm";
                  reg = <0x0c>;
                  status = "okay";
                  VDD-supply = <0xffffffff>;
                  phandle = <0x02>;
                };
              };
            };

            fragment@101 {
              target = <0xffffffff>;
              phandle = <0x06>;

              __overlay__ {
                status = "okay";
                phandle = <0x0a>;

                port {

                  endpoint {
                    remote-endpoint = <0x04>;
                    clock-lanes = <0x00>;
                    data-lanes = <0x01 0x02>;
                    clock-noncontinuous;
                    phandle = <0x03>;
                  };
                };
              };
            };

            fragment@102 {
              target = <0xffffffff>;

              __dormant__ {
                compatible = "brcm,bcm2835-unicam-legacy";
              };
            };

            __overrides__ {
              rotation = [00 00 00 01 72 6f 74 61 74 69 6f 6e 3a 30 00];
              orientation = [00 00 00 01 6f 72 69 65 6e 74 61 74 69 6f 6e 3a 30 00];
              media-controller = [00 00 00 00 21 31 30 32 00];
              cam0 = <0x05 0x74617267 0x65743a30 0x3d00ffff 0xffff0000 0x67461 0x72676574 0x3a303d00 0xffffffff 0x07 0x74617267 0x65743a30 0x3d00ffff 0xffff0000 0x87461 0x72676574 0x3a303d00 0xffffffff 0x01 0x636c6f63 0x6b733a30 0x3d00ffff 0xffff0000 0x17661 0x6e61312d 0x73757070 0x6c793a30 0x3d00ffff 0xffff0000 0x25644 0x442d7375 0x70706c79 0x3a303d00 0xffffffff>;
              vcm = [00 00 00 02 73 74 61 74 75 73 00 00 00 00 00 3d 34 00];
              link-frequency = [00 00 00 04 6c 69 6e 6b 2d 66 72 65 71 75 65 6e 63 69 65 73 23 30 00];
            };

            __symbols__ {
              clk_frag = "/fragment@1";
              reg_frag = "/fragment@3";
              cam_reg = "/fragment@3/__overlay__";
              i2c_frag = "/fragment@100";
              cam_node = "/fragment@100/__overlay__/imx708@1a";
              cam_endpoint = "/fragment@100/__overlay__/imx708@1a/port/endpoint";
              vcm_node = "/fragment@100/__overlay__/dw9817@c";
              csi_frag = "/fragment@101";
              csi = "/fragment@101/__overlay__";
              csi_ep = "/fragment@101/__overlay__/port/endpoint";
            };

            __fixups__ {
              i2c0if = "/fragment@0:target:0";
              cam1_clk = "/fragment@1:target:0", "/fragment@100/__overlay__/imx708@1a:clocks:0";
              i2c0mux = "/fragment@2:target:0";
              cam1_reg = "/fragment@3:target:0", "/fragment@100/__overlay__/imx708@1a:vana1-supply:0", "/fragment@100/__overlay__/dw9817@c:VDD-supply:0";
              i2c_csi_dsi = "/fragment@100:target:0";
              cam_dummy_reg = "/fragment@100/__overlay__/imx708@1a:vana2-supply:0", "/fragment@100/__overlay__/imx708@1a:vdig-supply:0", "/fragment@100/__overlay__/imx708@1a:vddl-supply:0";
              csi1 = "/fragment@101:target:0", "/fragment@102:target:0";
              i2c_csi_dsi0 = "/__overrides__:cam0:14";
              csi0 = "/__overrides__:cam0:32";
              cam0_clk = "/__overrides__:cam0:50", "/__overrides__:cam0:86";
              cam0_reg = "/__overrides__:cam0:68", "/__overrides__:cam0:110", "/__overrides__:cam0:132";
            };

            __local_fixups__ {

              fragment@4 {
                target = <0x00>;

                __overlay__ {
                  lens-focus = <0x00>;
                };
              };

              fragment@100 {

                __overlay__ {

                  imx708@1a {

                    port {

                      endpoint {
                        remote-endpoint = <0x00>;
                      };
                    };
                  };
                };
              };

              fragment@101 {

                __overlay__ {

                  port {

                    endpoint {
                      remote-endpoint = <0x00>;
                    };
                  };
                };
              };

              __overrides__ {
                rotation = <0x00>;
                orientation = <0x00>;
                cam0 = <0x00 0x12 0x24 0x36 0x48 0x5a 0x72>;
                vcm = <0x00>;
                link-frequency = <0x00>;
              };
            };
          };
        '';
      }
    ];
  };

  boot.initrd.supportedFilesystems.zfs = false;
  boot.supportedFilesystems.zfs = false;
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

  services.ustreamer = {
    enable = true;
    extraArgs = [
      "--resolution=1280x720"
      "--desired-fps=20"
      "--encoder=HW"
      "--format=MJPEG"
    ];
  };

  system.stateVersion = "25.05";
}
