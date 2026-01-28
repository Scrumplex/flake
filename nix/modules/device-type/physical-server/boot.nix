{...}: {
  flake.modules.nixos."physical-server" = {
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      initrd.systemd.enable = true;
    };
  };
}
