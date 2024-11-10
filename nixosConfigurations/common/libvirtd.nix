{pkgs, ...}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
      vhostUserPackages = [pkgs.virtiofsd];
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;
}
