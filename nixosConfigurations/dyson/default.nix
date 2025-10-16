{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "dyson";
    modules = [
      ../common
      ../common/boot
      ../common/boot/plymouth.nix
      ../common/desktop
      ../common/desktop/anydesk.nix
      ../common/desktop/bitwarden.nix
      ../common/desktop/chromium.nix
      ../common/desktop/evolution.nix
      ../common/desktop/firefox.nix
      ../common/desktop/fonts.nix
      ../common/desktop/fuzzel.nix
      ../common/desktop/gaming.nix
      ../common/desktop/gtk
      ../common/desktop/image-viewer.nix
      ../common/desktop/inhibridge.nix
      ../common/desktop/keyring.nix
      ../common/desktop/kitty.nix
      ../common/desktop/mako.nix
      ../common/desktop/messengers.nix
      ../common/desktop/niri.nix
      ../common/desktop/orca-slicer.nix
      ../common/desktop/polkit-agent.nix
      ../common/desktop/portfolio-performance.nix
      ../common/desktop/poweralertd.nix
      ../common/desktop/qt
      ../common/desktop/screenshot-bash.nix
      ../common/desktop/session-lock.nix
      ../common/desktop/swayidle.nix
      ../common/desktop/waybar.nix
      ../common/desktop/wayvnc.nix
      ../common/desktop/wlogout.nix
      ../common/desktop/wlsunset.nix
      ../common/desktop/wob.nix
      ../common/git.nix
      ../common/gpg.nix
      ../common/home.nix
      ../common/libvirtd.nix
      ../common/neovim.nix
      ../common/pkgs
      ../common/podman.nix
      ../common/printing.nix
      ../common/pulsar-x2v2.nix
      ../common/remote-build-consumer.nix
      ../common/rtl-sdr.nix

      ./configuration.nix
    ];
  };
}
