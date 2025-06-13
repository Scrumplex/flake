{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "hetzner-arm-desktop";
    modules = [
      ../common
      ../common/boot
      ../common/desktop
      ../common/desktop/firefox.nix
      ../common/desktop/fuzzel.nix
      ../common/desktop/gtk
      ../common/desktop/image-viewer.nix
      ../common/desktop/keyring.nix
      ../common/desktop/kitty.nix
      ../common/desktop/mako.nix
      ../common/desktop/pipewire
      ../common/desktop/polkit-agent.nix
      ../common/desktop/poweralertd.nix
      ../common/desktop/qt
      ../common/desktop/session-lock.nix
      ../common/desktop/sway.nix
      ../common/desktop/swayidle.nix
      ../common/desktop/waybar.nix
      ../common/desktop/wlogout.nix
      ../common/desktop/wob.nix
      ../common/fish.nix
      ../common/git.nix
      ../common/home.nix
      ../common/htop.nix
      ../common/misc.nix
      ../common/mpv.nix
      ../common/neovim.nix
      ../common/nix.nix
      ../common/nix-index.nix
      ../common/openssh.nix
      ../common/pkgs
      ../common/podman.nix
      ../common/ranger.nix
      ../common/regional.nix
      ../common/ssh.nix
      ../common/tty.nix
      ../common/utils.nix
      ../../home

      ./configuration.nix
    ];
  };
}
