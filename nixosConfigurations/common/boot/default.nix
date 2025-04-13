{
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote

    ./quiet.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    initrd.systemd.enable = true;

    kernel.sysctl."kernel.sysrq" = 1;
  };

  profile.boot.quiet = lib.mkDefault true;

  specialisation."verbose".configuration = {
    profile.boot.quiet = false;
  };
}
