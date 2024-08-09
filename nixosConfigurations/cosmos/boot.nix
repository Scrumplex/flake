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
}
