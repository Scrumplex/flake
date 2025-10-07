{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
}
