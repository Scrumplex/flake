{
  inputs,
  pkgs,
  ...
}: {
  boot = {
    tmp.useTmpfs = true;

    kernelPackages = inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.linuxKernel.packages.linux_rpi4;

    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      # Some gui programs need this
      "cma=128M"
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
      "cgroup_memory=1"
    ];
  };

  hardware.deviceTree.overlays = [
    # https://github.com/raspberrypi/linux/blob/rpi-6.6.y/arch/arm/boot/dts/overlays/gpio-fan-overlay.dts
    {
      name = "gpio-fan";
      dtsText = ''
        /dts-v1/;
        /plugin/;

        / {
          compatible = "brcm,bcm2835";

          fragment@0 {
            target-path = "/";
            __overlay__ {
              fan0: gpio-fan@0 {
                compatible = "gpio-fan";
                gpios = <&gpio 12 0>;
                gpio-fan,speed-map = <0    0>,
                           <5000 1>;
                #cooling-cells = <2>;
              };
            };
          };

          fragment@1 {
            target = <&cpu_thermal>;
            __overlay__ {
              polling-delay = <2000>;	/* milliseconds */
            };
          };

          fragment@2 {
            target = <&thermal_trips>;
            __overlay__ {
              cpu_hot: trip-point@0 {
                temperature = <55000>;	/* (millicelsius) Fan started at 55°C */
                hysteresis = <10000>;	/* (millicelsius) Fan stopped at 45°C */
                type = "active";
              };
            };
          };

          fragment@3 {
            target = <&cooling_maps>;
            __overlay__ {
              map0 {
                trip = <&cpu_hot>;
                cooling-device = <&fan0 1 1>;
              };
            };
          };

          __overrides__ {
            gpiopin = <&fan0>,"gpios:4", <&fan0>,"brcm,pins:0";
            temp = <&cpu_hot>,"temperature:0";
            hyst = <&cpu_hot>,"hysteresis:0";
          };
        };
      '';
    }
  ];
}
