{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "andromeda";
    modules = [
      ../common
      ../common/boot
      ../common/desktop
      ../common/desktop/evolution.nix
      ../common/desktop/fonts.nix
      ../common/desktop/gtk
      ../common/desktop/image-viewer.nix
      ../common/desktop/inhibridge.nix
      ../common/desktop/keyring.nix
      ../common/desktop/orca-slicer.nix
      ../common/desktop/polkit-agent.nix
      ../common/desktop/portfolio-performance.nix
      ../common/desktop/qt
      ../common/gpg.nix
      ../common/home.nix
      ../common/libvirtd.nix
      ../common/misc.nix
      ../common/podman.nix
      ../common/printing.nix
      ../common/pulsar-x2v2.nix
      ../common/remote-build-provider.nix
      ../common/rtl-sdr.nix

      ./configuration.nix
    ];
  };
}
