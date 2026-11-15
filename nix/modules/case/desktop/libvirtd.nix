{config, ...}: {
  flake.modules.nixos."ext-libvirtd" = {pkgs, ...}: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;

    users.users."${config.flake.meta.username}".extraGroups = ["libvirtd"];
  };
}
