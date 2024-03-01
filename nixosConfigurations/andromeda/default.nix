{lib', ...}: {
  flake.nixosConfigurations = lib'.mkHost {
    hostName = "andromeda";
    system = "x86_64-linux";

    modules = [
      ../common
      ../common/beets.nix
      ../common/bluetooth.nix
      ../common/boot.nix
      ../common/desktop
      ../common/desktop/chromium.nix
      ../common/desktop/evolution.nix
      ../common/desktop/firefox.nix
      ../common/desktop/fuzzel.nix
      ../common/desktop/gaming.nix
      ../common/desktop/gtk
      ../common/desktop/hyprland.nix
      ../common/desktop/image-viewer.nix
      ../common/desktop/keyring.nix
      ../common/desktop/kitty.nix
      ../common/desktop/mako.nix
      ../common/desktop/nextcloud-client.nix
      ../common/desktop/obs.nix
      ../common/desktop/pipewire
      ../common/desktop/polkit-agent.nix
      ../common/desktop/qt
      ../common/desktop/screenshot-bash.nix
      ../common/desktop/session-lock.nix
      ../common/desktop/swayidle.nix
      ../common/desktop/vr
      ../common/desktop/waybar.nix
      ../common/desktop/wlogout.nix
      ../common/desktop/wlsunset.nix
      ../common/desktop/wob.nix
      ../common/desktop/xwaylandvideobridge.nix
      ../common/fish.nix
      ../common/flatpak.nix
      ../common/git.nix
      ../common/gpg.nix
      ../common/home.nix
      ../common/htop.nix
      ../common/misc.nix
      ../common/mpd.nix
      ../common/mpv.nix
      ../common/neovim.nix
      ../common/nix.nix
      ../common/nix-index.nix
      ../common/nvd.nix
      ../common/password-store.nix
      ../common/pkgs
      ../common/printing.nix
      ../common/ranger.nix
      ../common/regional.nix
      ../common/rtl-sdr.nix
      ../common/ssh.nix
      ../common/syncthing.nix
      ../common/utils.nix
      ../common/v4l2loopback.nix
      ../../home

      ./configuration.nix
    ];
  };
}
