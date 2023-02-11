{ config, pkgs, ... }:

{
  boot = {
    # Needs unstable nixpkgs!
    bootspec.enable = true;

    loader = {
      systemd-boot.enable = true;
      systemd-boot.consoleMode = "max";
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    # quieter boot
    initrd.verbose = false;
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
  };
}
