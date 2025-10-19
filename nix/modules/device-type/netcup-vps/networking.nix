{
  flake.modules.nixos.netcup-vps = {
    networking = {
      useDHCP = false;
      interfaces.ens3.useDHCP = true;
    };

    services.qemuGuest.enable = true;
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
